buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("com.google.gms:google-services:4.4.2")
    }
}

subprojects {
    afterEvaluate {
        if (name == "qr_code_scanner") {
            extensions.findByName("android")?.let { ext ->
                @Suppress("UNCHECKED_CAST")
                val androidExt = ext as com.android.build.gradle.LibraryExtension
                if (androidExt.namespace == null || androidExt.namespace!!.isBlank()) {
                    androidExt.namespace = "com.example.qr_code_scanner"
                }
            }
        }
        
        extensions.findByName("android")?.let { ext ->
            val androidExt = ext as? com.android.build.gradle.BaseExtension
            androidExt?.compileOptions {
                sourceCompatibility = JavaVersion.VERSION_11
                targetCompatibility = JavaVersion.VERSION_11
            }
        }

        tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>().configureEach {
            kotlinOptions {
                jvmTarget = "11"
            }
        }
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
