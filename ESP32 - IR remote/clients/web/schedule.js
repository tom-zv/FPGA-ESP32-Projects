document.addEventListener('DOMContentLoaded', function() {
    fetchSchedules(); // Fetch and display schedules on page load

});
window.onload = function() {
    document.body.style.display = "flex";
};
function postSchedule(){
    var index = document.getElementById("index").value;
    var hour_on = document.getElementById("hour_on").value;
    var minute_on = document.getElementById("minute_on").value;
    var hour_off = document.getElementById("hour_off").value;
    var minute_off = document.getElementById("minute_off").value;
    var wday_bitmask = document.getElementById("wday_bitmask").value;

    var schedule_data = index + " " + hour_on + " " + minute_on + " " + hour_off + " " + minute_off + " " + wday_bitmask;

    var xhr = new XMLHttpRequest();
    xhr.open("POST", "/schedule/update", true);
    xhr.setRequestHeader("Content-Type", "text/plain");

    xhr.onreadystatechange = function () {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            var status = xhr.status;
            if (status === 0 || (status >= 200 && status < 400)) {
                // The request has been completed successfully
                console.log("Schedule posted successfully!");
                alert("Schedule posted successfully!");
                fetchSchedules();
            } else {
                // Oh no! There has been an error with the request!
                console.error("Failed to post schedule:", xhr.responseText);
                alert("Failed to post schedule!");
            }
        }
    };
    xhr.send(schedule_data);
}

function deleteSchedule(){
    var index = document.getElementById("index").value;
    var xhr = new XMLHttpRequest();
    xhr.open("POST", "/schedule/delete", true);
    xhr.setRequestHeader("Content-Type", "text/plain");

    xhr.onreadystatechange = function () {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            var status = xhr.status;
            if (status === 0 || (status >= 200 && status < 400)) {
                // The request has been completed successfully
                console.log("Schedule deleted successfully!");
                alert("Schedule deleted successfully!");
                fetchSchedules();
            } else {
                // Oh no! There has been an error with the request!
                console.error("Failed to post schedule:", xhr.responseText);
                alert("Failed to delete schedule!");
            }
        }
    };
    xhr.send(index);
}

function displaySchedules(schedules) {
    const table = document.createElement('table');
    table.className = 'schedule-table';

    
    const thead = table.createTHead();
    const headerRow = thead.insertRow();
    const headers = ['Hour On', 'Minute On', 'Hour Off', 'Minute Off', 'Weekday Bitmask'];
    headers.forEach(text => {
        const th = document.createElement('th');
        th.textContent = text;
        headerRow.appendChild(th);
    });

    
    const tbody = table.createTBody();
    schedules.forEach(schedule => {
        const row = tbody.insertRow();
        row.insertCell().textContent = schedule.hour_on;
        row.insertCell().textContent = schedule.minute_on;
        row.insertCell().textContent = schedule.hour_off;
        row.insertCell().textContent = schedule.minute_off;
        row.insertCell().textContent = schedule.wdaybitmask.toString(2);
    });

    const container = document.getElementById('scheduleContainer');
    container.innerHTML = ''; // Clear previous content
    container.appendChild(table);
}

function fetchSchedules() {
    fetch('/schedule_table')
        .then(response => response.json())
        .then(data => displaySchedules(data))
        .catch(error => console.error('Error fetching schedules:', error));
}