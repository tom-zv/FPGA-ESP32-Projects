package com.example.acremote.network

import okhttp3.ConnectionPool
import okhttp3.OkHttpClient

import java.util.concurrent.TimeUnit
//import java.security.cert.X509Certificate
//import javax.net.ssl.SSLContext
//import javax.net.ssl.TrustManager
//import javax.net.ssl.X509TrustManager

// Create a singleton OkHttpClient instance
object HttpClient {
    private const val LAN_URL = "AC server LAN ip"
    private const val PUB_URL = "dDNS hostname" 
    private const val USE_PUB_URL = true
    val url = if (USE_PUB_URL) PUB_URL else LAN_URL

    private val connectionPool = ConnectionPool(
        maxIdleConnections = 5,    // Maximum number of idle connections
        keepAliveDuration = 5,     // Keep alive duration in minutes
        timeUnit = TimeUnit.MINUTES
    )

//    private val trustManager = getTrustManager() // used for accepting unsecure self-signed certs, for test/debug purposes

//    private val sslContext: SSLContext = SSLContext.getInstance("SSL").apply {
//        init(null, arrayOf<TrustManager>(trustManager), java.security.SecureRandom())
//    }

    val client: OkHttpClient = OkHttpClient.Builder()
        //.sslSocketFactory(sslContext.socketFactory, trustManager)
        //.hostnameVerifier { _, _ -> true }
        .connectionPool(connectionPool)
        .retryOnConnectionFailure(true) // Retry on connection failure
        .build()

//    private fun getTrustManager(): X509TrustManager {
//        return object : X509TrustManager {
//            override fun checkClientTrusted(chain: Array<X509Certificate>, authType: String) {}
//            override fun checkServerTrusted(chain: Array<X509Certificate>, authType: String) {}
//            override fun getAcceptedIssuers(): Array<X509Certificate> = arrayOf()
//        }
//    }
}