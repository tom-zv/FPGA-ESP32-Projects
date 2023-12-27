package com.example.acremote

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.acremote.ui.acControl.FanSpeedControl
import com.example.acremote.ui.acControl.ModeIcons
import com.example.acremote.ui.acControl.PowerButton
import com.example.acremote.ui.acControl.SwingButton
import com.example.acremote.ui.acControl.TemperatureControl
import com.example.acremote.ui.Footer
import com.example.acremote.ui.theme.BackgroundDark

@Composable
fun AcControlPage(viewModel: AcControlViewModel, onNavigate: (String) -> Unit) {
    val settings by viewModel.settingsState

    Surface(color = BackgroundDark, modifier = Modifier.fillMaxSize()) {
        Column(
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.Top,
            modifier = Modifier.padding(top = 64.dp)
        ) {
            Text(
                text = "AC Remote Control",
                color = Color.White,
                fontSize = 24.sp,
                fontWeight = FontWeight.Bold,
                modifier = Modifier.padding(bottom = 52.dp)

            )
            Spacer(modifier = Modifier.height(16.dp))

            PowerButton(isOn = settings.power == 1) {
                viewModel.postUpdate("POWER")
                viewModel.localUpdate("POWER")
            }

            Spacer(modifier = Modifier.height(68.dp))

            FanSpeedControl(
                fanSpeed = settings.fan,
                onFanDown = { viewModel.onFanDown() },
                onFanUp = { viewModel.onFanUp() })

            Spacer(modifier = Modifier.height(30.dp))

            TemperatureControl(
                temp = settings.temp,
                onTempDown = { viewModel.onTempDown() },
                onTempUp = { viewModel.onTempUp() })

            Spacer(modifier = Modifier.height(36.dp))

            SwingButton(isOn = settings.swing == 1) {
                viewModel.postUpdate("SWING")
                viewModel.localUpdate("SWING")
            }

            Spacer(modifier = Modifier.height(36.dp))

            ModeIcons(mode = settings.mode, onModeSelect = { mode ->
                viewModel.postUpdate(mode)
                viewModel.localUpdate(mode)
            })

            Spacer(modifier = Modifier.weight(1f))

            Footer(currentPage = "AcControl",onNavigate = onNavigate)
        }
    }
}