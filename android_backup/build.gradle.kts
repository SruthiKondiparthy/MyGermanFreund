// Top-level build file where you can add configuration options common to all sub-projects/modules.

buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // Android Gradle Plugin 8.3.1
        //classpath("com.android.tools.build:gradle:8.5.2")
	classpath ("com.android.tools.build:gradle:8.6.0")
	classpath ("org.jetbrains.kotlin:kotlin-gradle-plugin:1.9.25")
        // Google services (for Firebase)
        classpath("com.google.gms:google-services:4.4.2")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Optional: clean task
tasks.register<Delete>("clean") {
    delete(rootProject.buildDir)
}
