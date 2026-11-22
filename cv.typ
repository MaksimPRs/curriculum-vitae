#import "dsl.typ" // by default imported within a 'dsl' namespace

#show: dsl.cv-theme 

#dsl.name-in-header("Maksim Protasevich")

#dsl.contact-info(
  content-left: ("Poland"),
  content-right: (
    link("mailto:bnqc7um7k@mozmail.com")[Email],
    link("https://linkedin.com/in/maksim-protasevich-31796356/")[LinkedIn], // Use short link
  ),
)

#dsl.summary[
  Software engineer with over 12 years of experience in backend development of reliable and distributed systems with a focus on Rust. Proven experience of making performant and scalable systems with robustness in mind. As a dev with education in math, I aim to not just create software, but make it easier for others to maintain it.
]

#dsl.experience(
  dsl.entry(
    position: "Java Software Engineer",
    company: "Spribe, Remote",
    dates: (datetime(day: 19, month: 12, year: 2022), datetime(day: 17, month: 9, year: 2026)),
    achievements: [
      - Designed an internal *Java* framework for slot games, which later has been used within our team. It simplified maintainability and reduced development time of new games by providing appropriate abstractions to the domain model, helping developers to focus on business logic rather than copying low-level implementation;
      - Proposed and implemented an internal multi-layered caching mechanism on top of *Caffeine* and *Redis* implementations for L1 and L2 levels respectively for a library. It aimed to reduce load on one of the highly-demanded internal service;
      - Initiated research on efficiency of serialization protocols and with the help of *WireShark* proved the lack of benefit from switching between existing and proposed protocols in terms of traffic size. As a result, that saved us a significant amount of time and resources;
      - Simplified game balancing process for our game designer, by designing a tool which allowed him to execute simulations on running instances of our games and adjust its configurations at runtime, eliminating the need to restart the app on every modification of weights.
    ],
    tech-stack: ("Java 17-25", "Spring Boot", "PostgreSQL", "Redis", "Caffeine", "Docker", "OpenLens", "Mockito", "JUnit5", "Instancio"),
  ),
  dsl.entry(
    position: "Java Software Engineer",
    company: "Surprise.com, Lviv, Ukraine, Hybrid",
    dates: (datetime(day: 21, month: 12, year: 2021), datetime(day: 12, month: 9, year: 2022)),
    achievements: [
      - Designed a distributed wallet-service based on SAGA pattern;
      - Reimplemented a part of monolithic Ruby application by providing 2 Java microservices implementations, made from scratch;
      - Communicated with the devops team to help them improve the maintenance over our infrastructure and speed up builds by addressing caching issues.
    ],
    tech-stack: ("Java 17", "Spring Boot", "PostgreSQL", "AWS", "Docker", "OpenLens", "Redis", "Mockito", "JUnit")
  ),
  dsl.entry(
    position: "Java Software Engineer",
    company: "ObjectStyle, Minsk, Belarus, Hybrid ",
    dates: (datetime(day: 1, month: 12, year: 2019), datetime(day: 3, month: 11, year: 2021)),
    achievements: [
      - Maintained 3 projects on my own;
      - Unified and simplified CI/CD flows for a bunch of projects within the company with the help of Bamboo Specs.
    ],
    tech-stack: ("Java 8", "Bootique", "Apache Cayenne", "LinkMove", "Docker", "Bamboo Specs")
  ),
  dsl.entry(
    position: "Java Software Engineer",
    company: "Synesis, Minsk, Belarus",
    dates: (datetime(day: 1, month: 8, year: 2017), datetime(day: 1, month: 8, year: 2019)),
    achievements: [
      - Designed and implemented new communication protocol for the existing messenger app, preserving backward compatibility with old clients (exclusively for transition period, as far as old approach was very inefficient);
      - Designed new DB structure for effective data storage and data reads;
      - Accomplished a zero-downtime migration on a schemaless DB named Datastore with 95% of data preservation;
      - All the changes in total resulted in:
        - Reduced total bills on cloud infrastructure by 66%;
        - Reduced load on Datastore by 45%;
        - Let us reduce instance count by 50%;
        - P99 latency per request reduced from roughly 4s to less than 250ms.
    ],
    tech-stack: ("Java 8", "Spring Framework", "GAE Endpoints", "GAE Datastore", "GAE Memcache", "Cloud Tasks (former Task Queue)", "Swagger", "Elasticsearch", "TestNG", "Mockito")
  ),
  pagebreak(),
  dsl.entry(
    position: "Java Software Engineer",
    company: "ISSoft Solutions (Coherent Solutions), Minsk, Belarus",
    dates: (datetime(day: 1, month: 6, year: 2014), datetime(day: 7, month: 4, year: 2017)),
    achievements: [
      - Started to promote new language features to the team as soon Java 8 has been approved for the project. Even though I’ve been just a junior, my team mates valued my suggestions as those made our code way cleaner.
    ],
    tech-stack: ("Java 6-8", "Spring Framework", "Spring MVC", "Hybris", "guava")
  )
)

#dsl.education(
  dsl.entry(
    position: "Student",
    company: "Rust Live Certification Accelerator, Let’s Get Rusty",
    dates: (datetime(day: 13, month: 9, year: 2026), datetime(day: 1, month: 4, year: 2027)),
    achievements: [
      - Designed and implemented a distributed in-memory KV-storage based on the RAFT algorithm. #link("https://github.com/MaksimPRs/kiwi/")[Project Link]
    ]
  ),
  dsl.entry(
    position: "Computer Science, Bachelor’s degree",
    company: "Belarusian State University, Faculty of Applied Mathematics and Computer Science, Minsk, Belarus",
    dates: (none, datetime(day: 17, month: 7, year: 2015)),
    achievements: [
      - Studied distributed systems in general;
      - Worked on concurrency issues;
      - Made research on efficiency of multiprocessing on CUDA framework compared to other tools for multi-core processing on graphic cards.
    ]
  ),
)

// Any section that is not a list of entries — plain content, any markup:
// #section("Projects")[
//   - Thing one
//   - Thing two
// ]

#dsl.skills(
  title: "Technical Skills",
  Frameworks: ("Java 17-25", "Rust", "Spring", "JUnit"),
  Tools: ("Swagger", "PostgreSQL", "Redis", "Docker", "K8s", "OpenLens", "GCP", "AWS"),
)
