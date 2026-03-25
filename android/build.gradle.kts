@file:Suppress("DSL_SCOPE_VIOLATION")
import com.android.build.gradle.BaseExtension

allprojects {
    repositories {
        google()
        mavenCentral()
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

// --- ATTACK PROTECTION: Works with Gradle 8.14 ---
subprojects {
    // This block forces safe versions across all plugins (JDOM, Netty, etc.)
    configurations.configureEach {
        resolutionStrategy.eachDependency {
            when {
                requested.group == "org.jdom" && requested.name == "jdom2" -> useVersion("2.0.6.1")
                requested.group == "io.netty" -> useVersion("4.1.115.Final")
                requested.group == "org.apache.commons" && requested.name == "commons-compress" -> useVersion("1.26.0")
                requested.group == "junit" && requested.name == "junit" -> useVersion("4.13.2")
            }
        }
    }

    // FIX: Assigns namespace to plugins that are missing it (fixes Gradle 8+ requirements)
    plugins.withType<com.android.build.gradle.api.AndroidBasePlugin> {
        val extension = extensions.findByType<BaseExtension>()
        if (extension?.namespace == null) {
            extension?.namespace = "com.example." + project.name.replace("-", ".")
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}