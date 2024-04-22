Delayed::Worker.queue_attributes = {
  high_priority: { priority: -10 },
  cleanup: { priority: 1 },
  imports: { priority: 5 },
  long_cleanup: { priority: 7 },
  low_priority: { priority: 10 },
}
