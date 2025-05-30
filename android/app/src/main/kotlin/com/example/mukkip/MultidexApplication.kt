package com.example.mukkip

import android.app.Application
import androidx.multidex.MultiDex
import android.content.Context

class MultidexApplication : Application() {
    override fun attachBaseContext(base: Context) {
        super.attachBaseContext(base)
        MultiDex.install(this)
    }
} 