#!/bin/sh

# ./create.sh <project_name> <package_name>
# ./create.sh demo garden.bots

# === create a Scala Project ===
mkdir $1
cd $1
mkdir -p src/${2//./\/}

# --- generate README.md ---
cat > README.md << EOF
# $1

EOF

# --- generate source code: Main.java ---
cat > src/${2//./\/}/Main.java << EOF
package $2;

import java.lang.String;
import java.lang.System;

public class Main {

  public static void main(String[] args) {
    System.out.println("Hi!");
  }
}
EOF

# --- generate pom.xml ---
cat > pom.xml << EOF
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>$1</groupId>
    <artifactId>$1</artifactId>
    <version>1.0-SNAPSHOT</version>

    <packaging>jar</packaging>

    <name>$1</name>

    <build>
        <sourceDirectory>src</sourceDirectory>
        <!--<testSourceDirectory>test</testSourceDirectory>-->

        <resources>
            <resource>
                <directory>src</directory>
                <excludes>
                    <exclude>**/*.java</exclude>
                </excludes>
            </resource>
        </resources>

        <plugins>

            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-compiler-plugin</artifactId>
                <version>3.0</version>
                <configuration>
                    <source>1.8</source>
                    <target>1.8</target>
                </configuration>
            </plugin>


            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-assembly-plugin</artifactId>
                <version>2.2.2</version>
                <configuration>
                    <descriptorRefs>
                        <descriptorRef>jar-with-dependencies</descriptorRef>
                    </descriptorRefs>
                    <archive>
                        <manifest>
                            <mainClass>$2.Main</mainClass>
                        </manifest>
                    </archive>
                    <appendAssemblyId>false</appendAssemblyId>
                    <outputDirectory>./</outputDirectory>
                    <finalName>$1.\${project.version}</finalName>
                </configuration>
            </plugin>

        </plugins>
    </build>

</project>
EOF

# generate build.sh

# --- generate: build.sh ---
cat > build.sh << EOF
mvn compile assembly:single
EOF

# --- generate: run.sh ---
cat > run.sh << EOF
java -jar $1.1.0-SNAPSHOT.jar
EOF

chmod +x *.sh

