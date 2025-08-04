// android/build.gradle.kts (Project-level)

buildscript {
    repositories {
        google()
        mavenCentral()
    }

    dependencies {
        classpath("com.android.tools.build:gradle:8.3.0")
        classpath("com.google.gms:google-services:4.4.1")
        // Explicitly declare the Kotlin Gradle Plugin version here for the build script.
        // This version should be compatible with your Firebase/Android dependencies.
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:2.1.0") // Updated to match Firebase dependencies
    }
}

allprojects {
    repositories {
        google()
        mavenCentral() // <--- FIX THIS LINE: Changed from 'mavenCenter' to 'mavenCentral()'
    }
}

// Redirect the build directory outside the project for faster builds or shared caching
val newBuildDir = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.set(newBuildDir)

// Configure each subproject to use a build directory inside the new shared build folder
subprojects {
    val newSubprojectBuildDir = newBuildDir.dir(project.name)
    project.layout.buildDirectory.set(newSubprojectBuildDir)
}

// Ensure subprojects are evaluated after ":app" project
subprojects {
    evaluationDependsOn(":app")
}

// Register a clean task to delete the shared build directory
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}