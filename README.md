# Bookmark Site

## Team
 - Samuel Kent | [Website](https://samthedude.github.io/) | [GitHub](https://github.com/SamTheDude) | [Linkedin](https://www.linkedin.com/in/samuel-kent-27378b1a9/)
 - Zbigniew Lisak
 - Jacob Crawley | [GitHub](https://github.com/jacob-crawley)
 - PingChenLin
 - Modestas Talanskas
 - Yi Jing Ng | [Linkedin](https://www.linkedin.com/in/yi-jing-ng-a0844a1a6)
 - Yao Li

 ## Explination

 This was made by the team above for an assessment, I'm publishing this out here as a reference for how to use sinatra as this would have been an invaluble resource for us at the start of this project. I haven't added a liscence to the project yet because I'm not sure about how I can liscence it just yet but I shall choose the most open one once I've combed through the project and made sure there's nothing that we can't liscence.

## First time Install

This was last tested using WSL Ubuntu 18.04 you may have an easier or harder time than me getting this to work depending entirely on the whim of the ruby gods. 
Make sure you have ruby correctly installed already.

### Commands

```
gem install bundler:1.17.2
sudo apt-get install sqlite3 libsqlite3-dev
bundle install
```

## System testing

There is both unit testing and full system testing in this but I know that the unit testing is broken for some reason, the site seems to work and so does the full system testing so I can only assume that the unit testing has broken somehow.

### Unit Testing
```
rake unittest
```
### Full System Testing
```
cucumber
```

## Deployment

### Database Manipulation
```
rake wipedb         # Completely destroys the database structure
rake resetdb        # Removes all the data from the databse
rake testdb         # Sets the database up with the bare minimum testing data
```

### Run Webserver
```
rake run            # Runs the server with no extra steps
rake testrun        # Resets the database to the testing data then runs (I use this one)
```

## Enjoy :D