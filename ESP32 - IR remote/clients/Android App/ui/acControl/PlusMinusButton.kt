package com.example.acremote.ui.acControl

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.unit.dp
import com.example.acremote.ui.theme.Primary

@Composable
fun PlusMinusButton(imageVector: ImageVector, contentDescription: String, onClick: () -> Unit) {
    IconButton(
        onClick = onClick, modifier = Modifier
            .clip(RoundedCornerShape(4.dp))
            .size(32.dp)
            .background(Primary)
    ) {
        Icon(
            imageVector = imageVector,
            contentDescription = contentDescription,
            tint = Color.White,
            modifier = Modifier.size(28.dp)
        )
    }
}