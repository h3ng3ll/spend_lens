plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    id("com.google.firebase.crashlytics")
    // END: FlutterFire Configuration
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.hengell.spendlens"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.hengell.spendlens"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        // Explicit — never left to `flutter.minSdkVersion`'s default.
        //
        // design_spendlens.md §6 specifies 21, but that predates the Apphud
        // decision and is UNACHIEVABLE with it: apphud 3.4.0 declares
        // minSdkVersion 26, so a lower value fails the manifest merge and the
        // app cannot be built at all. Highest floor among the dependencies
        // wins: apphud 26 > camera_android_camerax 23 > mlkit 21.
        // Raising it is the only way to ship the subscription SDK the spec
        // itself mandates (§6, "Apphud only, no custom StoreKit").
        minSdk = 26
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

dependencies {
    // M8: the native ML Kit Latin text-recognition SDK, called directly
    // from `OcrChannel.kt` (design_spendlens.md §6 — "no Kotlin needed for
    // OCR" means no custom recognition code is written, not that the
    // native SDK is unavailable to Kotlin). This is the SAME artifact the
    // `google_mlkit_text_recognition` Dart plugin already pulls in
    // transitively; declaring it explicitly here keeps the native OCR
    // channel resolvable even if that pub package's own dependency ever
    // changes.
    implementation("com.google.mlkit:text-recognition:16.0.1")
}

flutter {
    source = "../.."
}
