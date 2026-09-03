require "test_helper"

class GitRepositoryTest < ActiveSupport::TestCase
  include ActionMailer::TestHelper

  # note: this case does not send email anymore, a credential error on GH will just crash the task
  test "incorrect credentials for github" do
    website_with_github.update(access_token: 'wrong access token')
    VCR.use_cassette(location) do
      assert_raise Octokit::Unauthorized do
        provider = website_with_github.git_repository.send(:provider)
        provider.create_file '/path.txt', 'content'
        provider.push 'this is a commit'
      end
    end
  end

  test "file creation on github" do
    VCR.use_cassette(location) do
      assert_nothing_raised do
        provider = website_with_github.git_repository.send(:provider)
        provider.create_file 'test.txt', 'content'
        result = provider.push 'Creating test.txt file'
      end
    end
  end

  test "file update on github" do
    VCR.use_cassette(location) do
      assert_nothing_raised do
        provider = website_with_github.git_repository.send(:provider)
        provider.update_file 'test.txt', 'test.txt', 'new content'
        result = provider.push 'Updating test.txt file'
      end
    end
  end

  test "file move on github" do
    VCR.use_cassette(location) do
      assert_nothing_raised do
        provider = website_with_github.git_repository.send(:provider)
        provider.update_file 'new_test.txt', 'test.txt', 'new content'
        result = provider.push 'Moving test.txt file'
      end
    end
  end

  test "file destroy on github" do
    VCR.use_cassette(location) do
      assert_nothing_raised do
        provider = website_with_github.git_repository.send(:provider)
        provider.destroy_file 'new_test.txt'
        result = provider.push 'Destroying new_test.txt file'
      end
    end
  end

  test "order_batch sorts by path, deletion first" do
    provider = website_with_github.git_repository.send(:provider)
    items = [
      { path: "c.html", mode: '100644', type: 'blob', sha: nil },
      { path: "b.html", mode: '100644', type: 'blob', content: "from c to b" },
      { path: "b.html", mode: '100644', type: 'blob', sha: nil },
      { path: "a.html", mode: '100644', type: 'blob', content: "from b to a" }
    ]

    ordered = provider.send(:order_batch, items)

    assert_equal [
      ["a.html", false],
      ["b.html", true],
      ["b.html", false],
      ["c.html", true]
    ], ordered.map { |item| [item[:path], provider.send(:deletion?, item)] }
  end

  test "commit chunking never splits a path's operations across two commits" do
    provider = website_with_github.git_repository.send(:provider)
    # 40 renamed/updated files => 80 items (delete + create per file), more than
    # COMMIT_BATCH_SIZE (75): this must be split into several commits, but never
    # in the middle of a single path's operations - otherwise the file would be
    # briefly deleted-then-recreated on the live site between the two pushes.
    items = 40.times.flat_map do |i|
      [
        { path: "file_#{i}.html", mode: '100644', type: 'blob', sha: nil },
        { path: "file_#{i}.html", mode: '100644', type: 'blob', content: "content #{i}" }
      ]
    end

    sub_batches = capture_sub_commits(provider) do
      provider.send(:create_commits_from_batch, items, 'Sync from osuny')
    end

    assert sub_batches.size > 1, "expected the 80 items to be split into several commits"
    # A chunk only cuts at a path boundary, so it may slightly overshoot
    # COMMIT_BATCH_SIZE by the size of the run that pushed it over - never more.
    sub_batches.each { |sub_batch| assert sub_batch.size <= Git::Providers::Github::COMMIT_BATCH_SIZE + 2 }
    # Every path's items must all be found in the very same single sub-commit.
    items.map { |item| item[:path] }.uniq.each do |path|
      containing = sub_batches.select { |sub_batch| sub_batch.any? { |item| item[:path] == path } }
      assert_equal 1, containing.size, "operations on #{path} were split across commits"
    end
  end

  test "a path collision between three different git_files still keeps that path's operations in one commit" do
    provider = website_with_github.git_repository.send(:provider)
    # Simulates two different `about` records (not just one update_file call)
    # colliding on the same target path: one being destroyed, another recreated,
    # padded with unrelated items so the shared path lands mid-batch.
    items = 40.times.map { |i| { path: "other_#{i}.html", mode: '100644', type: 'blob', content: "x" } }
    items += [
      { path: "shared.html", mode: '100644', type: 'blob', sha: nil },
      { path: "shared.html", mode: '100644', type: 'blob', sha: nil },
      { path: "shared.html", mode: '100644', type: 'blob', content: "new owner" }
    ]
    items += 40.times.map { |i| { path: "other_#{40 + i}.html", mode: '100644', type: 'blob', content: "x" } }

    sub_batches = capture_sub_commits(provider) do
      provider.send(:create_commits_from_batch, items, 'Sync from osuny')
    end

    containing = sub_batches.select { |sub_batch| sub_batch.any? { |item| item[:path] == "shared.html" } }
    assert_equal 1, containing.size, "the operations on shared.html were split across commits"
    shared_items = containing.first.select { |item| item[:path] == "shared.html" }
    # The redundant 2nd deletion is deduped by keep_item?: only the first
    # deletion and the final creation survive.
    assert_equal [true, false], shared_items.map { |item| provider.send(:deletion?, item) }
  end

  test "incorrect credentials for gitlab" do
    VCR.use_cassette(location) do
      assert_enqueued_emails 1 do
        website_with_gitlab.update(access_token: 'wrong access token')
        provider = website_with_gitlab.git_repository.send(:provider)
        provider.create_file '/path.txt', 'content'
        provider.push 'this is a commit'
      end
    end
  end

  test "file creation on gitlab" do
    VCR.use_cassette(location) do
      assert_nothing_raised do
        provider = website_with_gitlab.git_repository.send(:provider)
        provider.create_file 'test.txt', 'content'
        result = provider.push 'Creating test.txt file'
      end
    end
  end

  test "file update on gitlab" do
    VCR.use_cassette(location) do
      assert_nothing_raised do
        provider = website_with_gitlab.git_repository.send(:provider)
        provider.update_file 'test.txt', 'test.txt', 'new content'
        result = provider.push 'Updating test.txt file'
      end
    end
  end

  test "file move on gitlab" do
    VCR.use_cassette(location) do
      assert_nothing_raised do
        provider = website_with_gitlab.git_repository.send(:provider)
        provider.update_file 'new_test.txt', 'test.txt', 'new content'
        result = provider.push 'Moving test.txt file'
      end
    end
  end

  test "file destroy on gitlab" do
    VCR.use_cassette(location) do
      assert_nothing_raised do
        provider = website_with_gitlab.git_repository.send(:provider)
        provider.destroy_file 'new_test.txt'
        result = provider.push 'Destroying new_test.txt file'
      end
    end
  end

  private

  # Overrides the network-touching parts of create_commits_from_batch (the base
  # tree/branch lookup and the actual Octokit calls in create_sub_commit) on this
  # one-off provider instance, so we can exercise its real chunking/ordering
  # logic and capture, for each sub-commit it would have created, the exact
  # sub-batch it was given.
  def capture_sub_commits(provider)
    captured = []
    provider.define_singleton_method(:tree) { { sha: 'base-tree-sha' } }
    provider.define_singleton_method(:branch_sha) { 'base-commit-sha' }
    provider.define_singleton_method(:create_sub_commit) do |sub_batch, _message, _base_tree_sha, _base_commit_sha|
      captured << sub_batch
      { tree: { sha: "tree-#{captured.size}" }, sha: "commit-#{captured.size}" }
    end
    yield
    captured
  end
end
