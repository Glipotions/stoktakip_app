# Flutter specific rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Keep native methods
-keepclassmembers class * {
    native <methods>;
}

# Keep Serializable classes and their members
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    !static !transient <fields>;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# Keep the BuildConfig
-keep class com.stoktakip.local.app.BuildConfig { *; }

# Keep the support library
-keep class androidx.** { *; }
-keep interface androidx.** { *; }

# Keep flutter_thermal_printer classes
-keep class com.example.flutter_thermal_printer.** { *; }

# Keep Play Core classes
-keep class com.google.android.play.core.** { *; }
