# Terraling

https://terraling.com

Terraling is a Ruby on Rails web application to let you store and browse your linguistic data. It has extensive search features including the following:

* [Regular Search](https://github.com/linguisticexplorer/terraling/wiki/Regular-search)

* [Cross Search](https://github.com/linguisticexplorer/terraling/wiki/Cross-search)

* [Compare Search](https://github.com/linguisticexplorer/terraling/wiki/Compare-search)

* [Universal Implication Both Search](https://github.com/linguisticexplorer/terraling/wiki/Both-Implication)

* [Universal Implication Antecedent Search](https://github.com/linguisticexplorer/terraling/wiki/Antecedent-Implication)

* [Universal Implication Consequent Search](https://github.com/linguisticexplorer/terraling/wiki/Consequent-Implication)

* [Universal Implication Double Both Search](https://github.com/linguisticexplorer/terraling/wiki/Double-Both-Implication)

* [Geomapping](https://github.com/linguisticexplorer/terraling/wiki/Geomapping-feature) of all the searches above and filtering of results by category/row

* [Similarity Tree Search](https://github.com/linguisticexplorer/terraling/wiki/Similarity-tree)

## Installation

#### Requirements
* Ruby 2.6.5
* MySQL 5.7
* Docker Desktop

#### Instructions

* Clone the repository

    * `$ git clone git://github.com/linguisticexplorer/terraling.git`
    * `$ cd terraling`


* Pull the docker image

    * `$ docker pull terraling/terraling`


* Create your database configuration file

    * `$ touch config/database.yml`
    * `$ vim config/database.yml`


* Run the docker-compose script

    * `$ docker-compose up`


## Branch Status

### Sprint

[![Build Status](https://travis-ci.org/linguisticexplorer/terraling.png?branch=sprint)](https://travis-ci.org/linguisticexplorer/terraling)

## Testing the app

* First, run the test docker-compose script:

    * `$ docker-compose -f docker-compose.test.yml up`


* Then, enter the running container via:

    * `$ docker exec -it $(docker ps -aqf "name=terraling/terraling") /bin/bash`


* Run RSpec unit testing

    * `$ bundle exec rspec`

  
## Contributing

See [Contributing](Contributing.md).
  
## License
This project is under the MIT License.

Please have a look at the [LICENSE file](LICENSE).
