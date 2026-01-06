plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services") // 파일이 없다면 이 줄은 지우셔도 됩니다
}

android {
    namespace = "com.example.smart_recycle_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = "1.8"
    }

    sourceSets {
        getByName("main").java.srcDirs("src/main/kotlin")
    }

    defaultConfig {
        applicationId = "com.example.smart_recycle_app"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // [중요] Release 모드에서도 충돌 방지
            isMinifyEnabled = false
            isShrinkResources = false 
            signingConfig = signingConfigs.getByName("debug")
        }
        getByName("debug") {
            // [중요] Debug 모드 충돌 방지
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

dependencies {
    // 필요한 의존성
}