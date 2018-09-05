package home.milcon

import org.springframework.boot.SpringApplication
import org.springframework.boot.autoconfigure.SpringBootApplication

@SpringBootApplication
class MilconApplication {}

fun main(args: Array<String>) {
    SpringApplication.run(MilconApplication::class.java, *args)
}
