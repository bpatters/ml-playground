import org.apache.spark.sql.SparkSession
import org.apache.mxnet._

object SimpleApp {
  def main(args: Array[String]) {
    val logFile = "/usr/local/spark/README.md" // Should be some file on your system
    val spark = SparkSession.builder.appName("Simple Application").getOrCreate()
    val logData = spark.read.textFile(logFile).cache()
    val numAs = logData.filter(line => line.contains("a")).count()
    val numBs = logData.filter(line => line.contains("b")).count()
    println(s"Lines with a: $numAs, Lines with b: $numBs")
    val arr = NDArray.ones(2, 3)
    println(s"Array.shape = ${arr.shape}")
    spark.stop()
  }
}