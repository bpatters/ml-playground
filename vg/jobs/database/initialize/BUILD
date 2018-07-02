load("@io_bazel_rules_scala//scala:scala.bzl", "scala_library")

scala_library(
	name="initialize",
	srcs=glob([
		"src/scala/com/pattersoncrew/*.scala"
		]),
	deps=[
	     "//jobs:spark_deps",
	],
)