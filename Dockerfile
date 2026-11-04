# Tomcat 9.0 with JDK 8. Upstream targets Tomcat 8.5 + Java 8, but 8.5 is EOL
# (its image stopped being rebuilt in Mar 2024). 9.0 keeps the javax.* Servlet API.
FROM tomcat:9.0-jdk8-temurin

# Optional: remove default webapps (docs, manager, etc.)
RUN rm -rf /usr/local/tomcat/webapps/*

# 1) Copy the WAR into webapps (deploys as /referenceccdaservice)
#    If you want it at root (/), name it ROOT.war instead.
COPY referenceccdaservice.war /usr/local/tomcat/webapps/referenceccdaservice.war

# 2) Copy the Tomcat Context config file (this is the "referenceccdaservice.xml")
#    It MUST live under conf/Catalina/localhost/ for the default engine/host.
COPY configuration/referenceccdaservice.xml /usr/local/tomcat/conf/Catalina/localhost/referenceccdaservice.xml

COPY validator/configs /validator/configs
COPY validator/scenarios /validator/scenarios

# 3) (Optional but recommended) increase heap for the in-memory vocab DB
#    They suggest ~5GB. Tune to your environment.
ENV JAVA_OPTS="-Xms1g -Xmx5g"

EXPOSE 8080
