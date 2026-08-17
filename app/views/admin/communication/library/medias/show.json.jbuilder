json.extract! @l10n, :name, :alt
thumb = ENV["KEYCDN_HOST"].present? ? @media.keycdn_thumb_url
                                    : url_for(@media.original_blob.variant(resize_to_fit: [600, nil]))
json.thumb thumb

