import java.util.Properties
import java.io.FileInputStream

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")

if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

plugins {
    id("com.android.application")

    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration

    id("kotlin-android")

    // Flutter Gradle Plugin must be applied after
    // Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.lwm.bestkits"

    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    // =========================================================
    // JAVA / CORE LIBRARY DESUGARING
    // =========================================================

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17

        // Required by flutter_local_notifications
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    // =========================================================
    // DEFAULT CONFIG
    // =========================================================

    defaultConfig {
        applicationId = "com.lwm.bestkits"

        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion

        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // =========================================================
    // SIGNING
    // =========================================================

    signingConfigs {
        create("release") {
            keyAlias =
                keystoreProperties["keyAlias"]?.toString() ?: ""

            keyPassword =
                keystoreProperties["keyPassword"]?.toString() ?: ""

            storePassword =
                keystoreProperties["storePassword"]?.toString() ?: ""

            storeFile =
                file(
                    keystoreProperties["storeFile"]?.toString() ?: ""
                )
        }
    }

    // =========================================================
    // BUILD TYPES
    // =========================================================

    buildTypes {
        getByName("release") {
            isMinifyEnabled = false
            isShrinkResources = false

            signingConfig = signingConfigs.getByName("release")

            proguardFiles(
                getDefaultProguardFile(
                    "proguard-android-optimize.txt"
                ),
                "proguard-rules.pro"
            )
        }
    }
}

// =============================================================
// CORE LIBRARY DESUGARING
// =============================================================
//
// Required for flutter_local_notifications.
// This fixes:
//
// "coreLibraryDesugaring configuration contains no dependencies"
//
// =============================================================

dependencies {
    coreLibraryDesugaring(
        "com.android.tools:desugar_jdk_libs:2.1.5"
    )
}

// =============================================================
// FLUTTER
// =============================================================

flutter {
    source = "../.."
}