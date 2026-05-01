# ─── Flutter ───────────────────────────────────────────────
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes SourceFile,LineNumberTable

# ─── flutter_local_notifications ───────────────────────────
-keep class com.dexterous.** { *; }
-keep class com.dexterous.flutterlocalnotifications.** { *; }

# ─── shared_preferences ────────────────────────────────────
-keep class io.flutter.plugins.sharedpreferences.** { *; }

# ─── timezone ──────────────────────────────────────────────
-keep class org.threeten.** { *; }

# ─── Kotlin ────────────────────────────────────────────────
-keep class kotlin.** { *; }
-keep class kotlin.Metadata { *; }
-dontwarn kotlin.**
-keepclassmembers class **$WhenMappings {
    <fields>;
}

# ─── Coroutines ────────────────────────────────────────────
-keepnames class kotlinx.coroutines.internal.MainDispatcherFactory {}
-keepnames class kotlinx.coroutines.CoroutineExceptionHandler {}
-keepclassmembernames class kotlinx.** {
    volatile <fields>;
}

# ✅ Play Core - R8 hatası için (Missing class fix)
-dontwarn com.google.android.play.core.**
-keep class com.google.android.play.core.** { *; }
-keep interface com.google.android.play.core.** { *; }

# ✅ Flutter Play Store Split Application
-dontwarn io.flutter.embedding.android.FlutterPlayStoreSplitApplication
-dontwarn io.flutter.embedding.engine.deferredcomponents.**
-keep class io.flutter.embedding.engine.deferredcomponents.** { *; }

# ✅ Java 8 source/target uyarılarını bastır
-dontwarn java.lang.invoke.**
-dontwarn **$$Lambda$*