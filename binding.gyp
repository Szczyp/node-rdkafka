{
  "targets": [
    {
      "target_name": "node-librdkafka",
      "sources": [
        "src/binding.cc",
        "src/callbacks.cc",
        "src/common.cc",
        "src/config.cc",
        "src/connection.cc",
        "src/errors.cc",
        "src/kafka-consumer.cc",
        "src/producer.cc",
        "src/topic.cc",
        "src/workers.cc",
        "src/admin.cc"
      ],
      "libraries": [
        "<!(echo $LIBRDKAFKA)/lib/librdkafka.so",
        "<!(echo $LIBRDKAFKA)/lib/librdkafka++.so"
      ],
      "include_dirs": [
        "<(module_root_dir)",
        "<!(node -e \"require('nan')\")",
        "<!(echo $LIBRDKAFKA)/include/librdkafka"
      ],
      "cflags_cc" : [
        "-std=c++11"
      ],
      "cflags_cc!": [
        "-fno-rtti"
      ]
    }
  ]
}
