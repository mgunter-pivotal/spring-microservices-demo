# Spring Microservices Demo

This project shows how to write
[Spring Boot](http://spring.io/projects/spring-boot) microservices,
and how to manage these API endpoints with
[Spring Cloud Gateway](http://spring.io/projects/spring-cloud-gateway).

## How does it work?

Spring Cloud Gateway enables you to manage your microservices API
endpoints from a single location. When you are building a big application,
made of several microservices, you could use Spring Cloud Gateway
to control how your API endpoints are seen by your clients. Using this
configuration, you could easily refactor your microservices
(divide a big microservice in two, merge smaller ones, etc.), at your
own pace. If you start from a monolith app, and you want to incrementally
build microservices by extracting API endpoints, Spring Cloud Gateway
is your best friend.

You define routes by code using the
[Spring Cloud Gateway API](https://cloud.spring.io/spring-cloud-static/spring-cloud-gateway/2.0.2.RELEASE/single/spring-cloud-gateway.html),
or by using a configuration file. This demo project is using the latter method.

Routes are defined in the application configuration file:
```yaml
spring:
  cloud:
    gateway:
      routes:
        - id: echo
          uri: ${microservices.echo}
          predicates:
            - Path=/api/echo/{segment}

        - id: time
          uri: ${microservices.time}
          predicates:
            - Path=/api/time/{segment}
          filters:
            - name: RequestRateLimiter
              args:
                redis-rate-limiter:
                  # How many requests per second do you want a user to be allowed to do?
                  replenish-rate: 1
                  # Maximum number of requests a user is allowed to do in a single second.
                  burst-capacity: 1

        - id: whoami
          uri: ${microservices.whoami}
          predicates:
            - Path=/api/whoami/{segment}

        - id: greeting
          uri: ${microservices.greeting}
          predicates:
            - Path=/api/greeting/{segment}
          filters:
            - name: Hystrix
              args:
                name: greetingFallback
                fallbackUri: forward:/api/fallback/greeting
```

## How to run this example?

Compile this project using a JDK 8:
```shell
C:\Users\user\projects\spring-microservices-demo> mvn clean package
```

You can now push all microservice to PCF (using manifest.yml in the top-level folder):
```shell
C:\Users\user\projects\spring-microservices-demo> cf push
```

### Configure gateway properties
Although each microservice is listening on its own route,
you should configure the microservice gateway to reach API endpoints.

Use a text editor to modify the following file:
C:\Users\User\projects\spring-microservices-demo\gateway\src\main\resources\application-cloud.yml


Configure the endpoints according to the random routes created for each microservice above.
```
microservices:
  echo: "https://echo-tired-duiker.cfapps.io/api/echo"
  time: "https://time-active-wombat.cfapps.io/api/time"
  greeting: "https://greeting-cheerful-pangolin.cfapps.io/api/greeting"
  whoami: "https://whoami-quick-dingo.cfapps.io/api/whoami"
```

<img src="https://imgur.com/download/oE26wdY"/>

### Deploy gateway to Cloud Foundry

(If available, create a Redis instance on your space prior
to pushing apps):
```shell
C:\Users\user\projects\spring-microservices-dem\gateway> cf push
```


## Contribute

Contributions are always welcome!

Feel free to open issues & send PR.

## License

Copyright &copy; 2019 Pivotal Software, Inc.

This project is licensed under the [Apache Software License version 2.0](https://www.apache.org/licenses/LICENSE-2.0).
