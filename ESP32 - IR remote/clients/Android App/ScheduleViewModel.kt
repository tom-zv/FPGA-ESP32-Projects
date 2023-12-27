package com.example.acremote

import android.util.Log
import androidx.compose.runtime.mutableStateListOf
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.example.acremote.network.HttpClient
import com.google.gson.Gson
import com.google.gson.JsonArray
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import okhttp3.MediaType.Companion.toMediaTypeOrNull
import okhttp3.Request
import okhttp3.RequestBody.Companion.toRequestBody
import java.io.IOException
import java.util.Locale


data class Schedule(
    var index: Int,
    var hourOn: Int,
    var minuteOn: Int,
    var hourOff: Int,
    var minuteOff: Int,
    var dayBitmask: Int,
    var isOn: Boolean
)

class ScheduleViewModel : ViewModel() {

    var schedules = mutableStateListOf<Schedule>()
        private set

    init {
        fetchSchedules()
    }

    fun saveSchedule(schedule: Schedule, index: Int) {
        val command = "$index ${
            String.format(
                Locale.US,
                "%02d %02d %02d %02d %07d",
                schedule.hourOn,
                schedule.minuteOn,
                schedule.hourOff,
                schedule.minuteOff,
                Integer.parseInt(Integer.toBinaryString(schedule.dayBitmask))
            )
        }"

        // Local update
        schedules.add(schedule)

        val requestBody = command.toRequestBody("text/plain; charset=utf-8".toMediaTypeOrNull())
        val request = Request.Builder().url("${HttpClient.url}/schedule/update").post(requestBody).build()
        viewModelScope.launch(Dispatchers.IO) {
            try {
                Log.d("HTTP_REQUEST","POST \"/schedule/update\" \"$command\"")
                HttpClient.client.newCall(request).execute().use { response ->
                    Log.d("HTTP_RESPONSE","$response")
                    if (!response.isSuccessful) throw IOException("Unexpected code $response")
                    fetchSchedules() // Refresh schedules after saving
                }
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
    }

    fun toggleSchedule(index: Int) {
        schedules[index].isOn = !schedules[index].isOn

        val requestBody = index.toString().toRequestBody("text/plain; charset=utf-8".toMediaTypeOrNull())
        val request = Request.Builder().url("${HttpClient.url}/schedule/toggle").post(requestBody).build()
        viewModelScope.launch(Dispatchers.IO) {
            try {
                Log.d("HTTP_REQUEST","POST \"/schedule/toggle\" body: \"$index\"")
                HttpClient.client.newCall(request).execute().use { response ->
                    Log.d("HTTP_RESPONSE","$response")
                    if (!response.isSuccessful) throw IOException("Unexpected code $response")
                    fetchSchedules() // Refresh schedules after toggling
                }
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
    }

    private fun fetchSchedules() {
        val request = Request.Builder().url("${HttpClient.url}/schedule_table").build()
        viewModelScope.launch(Dispatchers.IO) {
            try {
                Log.d("HTTP_REQUEST", "GET /schedule_table")
                HttpClient.client.newCall(request).execute().use { response ->
                    if (!response.isSuccessful) throw IOException("Unexpected code $response")
                    val json = response.body?.string()
                    Log.d("HTTP_RESPONSE", "Response: $json" ?: "No response body")
                    val jsonArray = Gson().fromJson(json, JsonArray::class.java)
                    val fetchedSchedules = jsonArray.map { element ->
                        val obj = element.asJsonObject
                        Schedule(
                            index = obj["index"].asInt,
                            hourOn = obj["hour_on"].asInt,
                            minuteOn = obj["minute_on"].asInt,
                            hourOff = obj["hour_off"].asInt,
                            minuteOff = obj["minute_off"].asInt,
                            dayBitmask = obj["wdaybitmask"].asInt,
                            isOn = obj["is_on"].asBoolean
                        )
                    }
                    schedules.clear()
                    schedules.addAll(fetchedSchedules)
                    Log.d("SCHEDULES_UPDATED", "Schedules updated: ${schedules.toList()}")
                }
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
    }

    fun deleteSchedule(index: Int) {
        val requestBody = index.toString().toRequestBody("text/plain; charset=utf-8".toMediaTypeOrNull())
        val request = Request.Builder().url("${HttpClient.url}/schedule/delete").post(requestBody).build()
        viewModelScope.launch(Dispatchers.IO) {
            try {
                Log.d("HTTP_REQUEST", "POST /schedule/delete body: \"$index\"")
                HttpClient.client.newCall(request).execute().use { response ->
                    if (!response.isSuccessful) throw IOException("Unexpected code $response")
                    val body = response.body?.string()
                    Log.d("HTTP_RESPONSE", body ?: "No response body")

                    schedules.removeAt(index)
                    fetchSchedules()
                }
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
    }
}