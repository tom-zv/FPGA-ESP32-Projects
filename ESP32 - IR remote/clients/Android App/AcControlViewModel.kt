package com.example.acremote

import android.app.Application
import android.content.Context.MODE_PRIVATE
import android.util.Log
import androidx.compose.runtime.State
import androidx.compose.runtime.mutableStateOf
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.viewModelScope
import com.example.acremote.network.HttpClient
import com.google.gson.Gson
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import okhttp3.MediaType.Companion.toMediaTypeOrNull
import okhttp3.Request
import okhttp3.RequestBody.Companion.toRequestBody
import java.io.IOException

data class ACSettings(
    var power: Int,
    var mode: Int,
    var fan: Int,
    var temp: Int,
    var swing: Int,
    var sleep: Int
)

class AcControlViewModel(application: Application) : AndroidViewModel(application) {
    val sharedPrefSettings = application.getSharedPreferences("ACRemoteSettings", MODE_PRIVATE)

    private val _settingsState = mutableStateOf(readSettingsFromSharedPrefs())
    val settingsState: State<ACSettings> = _settingsState

    private var debounceJob: Job? = null
    private var debouncedSettings: ACSettings? = null

    private var tempUpCount = 0
    private var tempDownCount = 0
    private var fanUpCount = 0
    private var fanDownCount = 0

    private fun readSettingsFromSharedPrefs(): ACSettings {
        val power = sharedPrefSettings.getInt("power", 0)
        val mode = sharedPrefSettings.getInt("mode", 0)
        val fan = sharedPrefSettings.getInt("fan", 0)
        val temp = sharedPrefSettings.getInt("temperature", 26)
        val swing = sharedPrefSettings.getInt("swing", 0)
        return ACSettings(power, mode, fan, temp, swing, 0)
    }

    private fun saveSettingsToSharedPrefs() {
        with(sharedPrefSettings.edit()) {
            putInt("power", _settingsState.value.power)
            putInt("mode", _settingsState.value.mode)
            putInt("fan", _settingsState.value.fan)
            putInt("temperature", _settingsState.value.temp)
            putInt("swing", _settingsState.value.swing)
            apply()
        }
    }

    init {
        fetchSettings()
        saveSettingsToSharedPrefs()
    }
    private fun fetchSettings() {
        val request = Request.Builder().url("${HttpClient.url}/ac_settings").build()
        viewModelScope.launch(Dispatchers.IO) {
            try {
                HttpClient.client.newCall(request).execute().use { response ->
                    if (!response.isSuccessful) throw IOException("Unexpected code $response")
                    val json = response.body?.string()

                    Log.d("HTTP_REQUEST", "GET /get_settings\n headers: { ${request.headers} }")
                    Log.d("HTTP_RESPONSE", "Response: $json\n" +
                            " headers: { ${response.headers} }")
                    val settings = Gson().fromJson(json, ACSettings::class.java)
                    withContext(Dispatchers.Main) {
                        debouncedSettings = settings
                        debounceUpdateInput(1000)
                    }
                }
            } catch (e: Exception) {
                Log.e("HTTP_ERROR", "Error: ${e.message}")
                e.printStackTrace()
            }
        }
    }

    fun postUpdate(command: String) {
        val requestBody = command.toRequestBody("text/plain; charset=utf-8".toMediaTypeOrNull())
        val request = Request.Builder().url("${HttpClient.url}/update").post(requestBody).build()
        viewModelScope.launch(Dispatchers.IO) {
            try {
                Log.d("HTTP_REQUEST", "POST /update - Body: $command")
                HttpClient.client.newCall(request).execute().use { response ->
                    if (!response.isSuccessful) throw IOException("Unexpected code $response")
                    fetchSettings()
                }
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
    }

    fun localUpdate(command: String) {
        _settingsState.value = when {
            command == "POWER" -> _settingsState.value.copy(power = 1 - settingsState.value.power)
            command.startsWith( "FAN_UP") -> settingsState.value.copy(fan = if (settingsState.value.fan < 3) settingsState.value.fan + 1 else settingsState.value.fan)
            command.startsWith("FAN_DOWN") -> settingsState.value.copy(fan = if (settingsState.value.fan > 0) settingsState.value.fan - 1 else settingsState.value.fan)
            command.startsWith("TEMP_UP") -> settingsState.value.copy(temp = if (settingsState.value.temp < 30) settingsState.value.temp + 1 else settingsState.value.temp)
            command.startsWith("TEMP_DOWN") -> settingsState.value.copy(temp = if (settingsState.value.temp > 16) settingsState.value.temp - 1 else settingsState.value.temp)
            command == "COOL" -> settingsState.value.copy(mode = 1)
            command == "HEAT" -> settingsState.value.copy(mode = 2)
            command == "DRY" -> settingsState.value.copy(mode = 4)
            command == "FAN" -> settingsState.value.copy(mode = 5)
            command == "SWING" -> settingsState.value.copy(swing = 1 - settingsState.value.swing)
            else -> _settingsState.value
        }
        saveSettingsToSharedPrefs()
    }

    fun onTempUp() {
        tempUpCount++
        debounceOutput("TEMP_UP $tempUpCount")
    }

    fun onTempDown() {
        tempDownCount++
        debounceOutput("TEMP_DOWN $tempDownCount")
    }

    fun onFanUp() {
        fanUpCount++
        debounceOutput("FAN_UP $fanUpCount")
    }

    fun onFanDown() {
        fanDownCount++
        debounceOutput("FAN_DOWN $fanDownCount")
    }

    private fun debounceUpdateInput(delayMillis: Long) {
        debounceJob?.cancel()
        debounceJob = viewModelScope.launch {
            delay(delayMillis)
            debouncedSettings?.let {
                _settingsState.value = it
                debouncedSettings = null
            }
        }
    }

    private fun debounceOutput(command: String) {
        localUpdate(command)
        debounceJob?.cancel()
        debounceJob = viewModelScope.launch {
            delay(500) // 500 ms debounce delay
            if (tempUpCount > 0) {
                postUpdate("TEMP_UP $tempUpCount")
            }
            if (tempDownCount > 0) {
                postUpdate("TEMP_DOWN $tempDownCount")
            }
            if (fanUpCount > 0) {
                postUpdate("FAN_UP $fanUpCount")
            }
            if (fanDownCount > 0) {
                postUpdate("FAN_DOWN $fanDownCount")
            }

            resetCounters()
        }
    }

    private fun resetCounters() {
        tempUpCount = 0
        tempDownCount = 0
        fanUpCount = 0
        fanDownCount = 0
    }
}

