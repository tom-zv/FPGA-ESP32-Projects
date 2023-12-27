@file:Suppress("AnimateAsStateLabel")

package com.example.acremote

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.activity.viewModels

import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController

import androidx.compose.material3.Surface
import androidx.compose.runtime.Composable

import com.example.acremote.ui.theme.ACRemoteTheme

class MainActivity : ComponentActivity() {
    private val acControlViewModel: AcControlViewModel by viewModels()
    private val scheduleViewModel: ScheduleViewModel by viewModels()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            ACRemoteTheme {
                Surface {
                    AppNavigation(acControlViewModel, scheduleViewModel)
                }
            }
        }
    }
}

@Composable
fun AppNavigation(acControlViewModel: AcControlViewModel, scheduleViewModel: ScheduleViewModel) {
    val navController = rememberNavController()

    NavHost(navController = navController, startDestination = "Schedule") {
        composable("AcControl") {
            AcControlPage(
                viewModel = acControlViewModel,
                onNavigate = { destination -> navController.navigate(destination) }
            )
        }
        composable("Schedule") {
            SchedulePage(
                viewModel = scheduleViewModel,
                onNavigate = { destination -> navController.navigate(destination) }
            )
        }
    }
}



