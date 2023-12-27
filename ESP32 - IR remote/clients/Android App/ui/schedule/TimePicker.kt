package com.example.acremote.ui.schedule

import android.util.Log
import androidx.compose.foundation.ExperimentalFoundationApi
import androidx.compose.foundation.gestures.snapping.rememberSnapFlingBehavior
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.offset
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.lazy.rememberLazyListState
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.drawBehind
import androidx.compose.ui.draw.drawWithContent
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.BlendMode
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.CompositingStrategy
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.acremote.ui.theme.Primary
import kotlinx.coroutines.launch


@Composable
fun TimePicker(
    initialHour: Int,
    initialMinute: Int,
    onTimeChange: (hour: Int, minute: Int) -> Unit
) {
    var selectedHour by remember { mutableIntStateOf(initialHour) }
    var selectedMinute by remember { mutableIntStateOf(initialMinute) }


    Box(
        modifier = Modifier
            .drawBehind {
                drawLine(
                    color = Color.White.copy(alpha = 0.8f),
                    start = Offset(-4.dp.toPx(), size.height / 2 - 19.dp.toPx()),
                    end = Offset(size.width + 4.dp.toPx(), size.height / 2 - 19.dp.toPx()),
                    strokeWidth = 1.dp.toPx()
                )
            }
            .drawBehind {
                drawLine(
                    color = Color.White.copy(alpha = 0.8f),
                    start = Offset(-4.dp.toPx(), size.height / 2 + 10.dp.toPx()),
                    end = Offset(size.width + 4.dp.toPx(), size.height / 2 + 10.dp.toPx()),
                    strokeWidth = 1.dp.toPx()
                )
            }
    ) {
        Row(
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.Center
        ) {
            NumberPicker(
                range = 0..23,
                selectedValue = selectedHour,
                onValueChange = { selectedHour = it }
            )
            Text(":", fontSize = 26.sp, modifier = Modifier
                .padding(horizontal = 4.dp)
                .offset(y = (-6).dp))
            NumberPicker(
                range = 0..59,
                selectedValue = selectedMinute,
                onValueChange = { selectedMinute = it }
            )
        }
    }

    LaunchedEffect(selectedHour, selectedMinute) {
        onTimeChange(selectedHour % 24, selectedMinute % 60)
    }
}

@Composable
@OptIn(ExperimentalFoundationApi::class)
fun NumberPicker(range: IntRange, selectedValue: Int, onValueChange: (Int) -> Unit) {
    val wrapAroundRange = (range + range + range).toList()
    val wrapAroundOffset = range.count()

    val listState = rememberLazyListState(
        initialFirstVisibleItemIndex = (selectedValue - 2)%wrapAroundOffset,
    )
    val coroutineScope = rememberCoroutineScope()

    LaunchedEffect(listState.isScrollInProgress) {
        if (!listState.isScrollInProgress) {
            val layoutInfo = listState.layoutInfo
            val middleItemIndex = (layoutInfo.viewportEndOffset + layoutInfo.viewportStartOffset) / 2
            val visibleItems = layoutInfo.visibleItemsInfo

            visibleItems.forEach { itemInfo ->
                val itemCenter = (itemInfo.offset + itemInfo.offset + itemInfo.size) / 2
                if (itemCenter in (middleItemIndex - itemInfo.size / 2)..(middleItemIndex + itemInfo.size / 2)) {

                    val newValue = (itemInfo.index % wrapAroundOffset) + wrapAroundOffset

                    if (newValue != selectedValue) {
                        onValueChange(newValue)
                        Log.d("NumberPicker", "Selected val - $newValue")
                    }
                }
            }
        }
    }

    Box{
        val itemHeight = 36.dp
        val totalHeight = (itemHeight.value * 5).dp

        LazyColumn(
            state = listState,
            flingBehavior = rememberSnapFlingBehavior(listState),
            modifier = Modifier
                .height(totalHeight)
                .graphicsLayer(compositingStrategy = CompositingStrategy.Offscreen)
                .drawWithContent {
                    drawContent()
                    drawRect(
                        brush = Brush.verticalGradient(
                            0f to Color.Transparent,
                            0.45f to Color.Red, 0.55f to Color.Red,
                            1f to Color.Transparent
                        ), blendMode = BlendMode.DstIn
                    )
                }
        ) {
            items(wrapAroundRange.toList()) { value ->
                Box(
                    modifier = Modifier
                        .padding(vertical = 1.dp),
                    contentAlignment = Alignment.Center

                ) {
                    Text(
                        text = value.toString().padStart(2, '0'),
                        fontSize = 25.sp,
                        modifier = Modifier.padding(vertical = 1.dp),
                        color = if (value == selectedValue % wrapAroundOffset) Primary else Color.White

                    )
                }
            }

        }
    }

    LaunchedEffect(selectedValue) {
        coroutineScope.launch {
            listState.scrollToItem(selectedValue - 2 )
        }
    }
}

