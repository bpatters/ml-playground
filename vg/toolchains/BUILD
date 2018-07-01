# //toolchains/BUILD
load("@io_bazel_rules_scala//scala:scala_toolchain.bzl", "scala_toolchain")

scala_toolchain(
  name="default_toolchain",
  scalacopts=[
    "-language:higherKinds",
    "-language:implicitConversions",
    "-deprecation",
    "-unchecked",
    "-feature",
    "-explaintypes",
  ],
  visibility=["//visibility:public"]
)

toolchain(
  name="default_scala_toolchain",
  toolchain_type="@io_bazel_rules_scala//scala:toolchain_type",
  toolchain="default_toolchain",
  visibility=["//visibility:public"]
)
