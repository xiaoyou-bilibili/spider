val scala3Version = "3.1.2"

lazy val root = project
  .in(file("."))
  .settings(
    name := "spider",
    version := "0.1.0-SNAPSHOT",

    scalaVersion := scala3Version,

    libraryDependencies += "org.scalameta" %% "munit" % "0.7.29" % Test,

    // 添加依赖 https://github.com/com-lihaoyi/requests-scala
    libraryDependencies += "com.lihaoyi" %% "requests" % "0.7.0"
  )
