plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.mukkip"
    compileSdk = 35
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.mukkip"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
            isMinifyEnabled = true
            proguardFiles(getDefaultProguardFile("proguard-android.txt"), "proguard-rules.pro")
        }
        debug {
            isMinifyEnabled = false
            signingConfig = signingConfigs.getByName("debug")
        }
    }
    
    // 최신 Flutter 버전에 맞게 변경된 APK 출력 설정
    applicationVariants.all {
        val variant = this
        variant.outputs.all {
            val output = this as com.android.build.gradle.internal.api.BaseVariantOutputImpl
            if (variant.buildType.name == "debug") {
                output.outputFileName = "app-debug.apk"
            } else {
                output.outputFileName = "app-release.apk"
            }
        }
        tasks.register("copy${variant.name.capitalize()}Apk") {
            dependsOn("assemble${variant.name.capitalize()}")
            doLast {
                val fromFile = File("${buildDir}/outputs/apk/${variant.name}/app-${variant.name}.apk")
                val toDir = File("${rootProject.projectDir}/../build/app/outputs/flutter-apk")
                toDir.mkdirs()
                val toFile = File(toDir, "app-${variant.name}.apk")
                if (fromFile.exists()) {
                    fromFile.copyTo(toFile, overwrite = true)
                    println("Copied APK to: ${toFile.absolutePath}")
                } else {
                    println("Source APK not found at: ${fromFile.absolutePath}")
                }
            }
        }
        tasks.named("assemble${variant.name.capitalize()}") {
            finalizedBy("copy${variant.name.capitalize()}Apk")
        }
    }
    
    lint {
        abortOnError = false
        checkReleaseBuilds = false
    }
    
    // ListingFileRedirectTask 문제를 해결하기 위한 설정
    tasks.withType<com.android.build.gradle.internal.tasks.ListingFileRedirectTask>().configureEach {
        // 입력 파일이 없는 경우 자동으로 생성하도록 doFirst 블록 추가
        doFirst {
            val file = File("$buildDir/outputs/apk/debug/output-metadata.json")
            if (!file.exists()) {
                file.parentFile.mkdirs()
                file.writeText("""
                    {
                      "version": 1,
                      "artifactType": {
                        "type": "APK",
                        "kind": "Directory"
                      },
                      "applicationId": "com.example.mukkip",
                      "variantName": "debug",
                      "elements": [
                        {
                          "type": "SINGLE",
                          "filters": [],
                          "attributes": [],
                          "versionCode": 1,
                          "versionName": "1.0.0",
                          "outputFile": "app-debug.apk"
                        }
                      ]
                    }
                """.trimIndent())
            }
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation("androidx.multidex:multidex:2.0.1")
    // 기존 플러그인 의존성은 자동으로 추가됩니다
}
