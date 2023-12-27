document.addEventListener('DOMContentLoaded', fetchSettings);

window.onload = function() {
    document.body.style.display = "flex";
};

function fetchSettings() {
    fetch('/ac_settings')
        .then(response => {
            if (!response.ok) {
                throw new Error('Failed to fetch settings');
            }
            return response.json();
        })
        .then(data => {
            console.log('Fetched settings:', data);
            updateUIBasedOnSettings(data);
        })
        .catch(error => console.error('Error fetching AC settings:', error));
}

function updateUIBasedOnSettings(settings) {
    const powerBtn = document.getElementById('power-button');
    const modeMapping = {
        1: 'COOL',
        2: 'HEAT',
        4: 'DRY',
        5: 'FAN'
    };

    powerBtn.classList.toggle('power-off', settings.power !== 1);
    powerBtn.classList.toggle('power-on', settings.power === 1);

    const modeString = modeMapping[settings.mode];

    ['COOL', 'HEAT', 'DRY', 'FAN'].forEach(mode => {
        const modeButton = document.getElementById(`mode-${mode}`);
        modeButton.classList.toggle('active', mode === modeString);
    });

    const fanSpeedDisplay = document.getElementById('fanSpeedDisplay');

    switch (settings.fan) {
        case 0:
            fanSpeedDisplay.innerHTML = '<i class="material-icons-outlined">signal_cellular_alt_1_bar</i>';
            break;
        case 1:
            fanSpeedDisplay.innerHTML = '<i class="material-icons-outlined">signal_cellular_alt_2_bar</i>';
            break;
        case 2:
            fanSpeedDisplay.innerHTML = '<i class="material-icons-outlined">signal_cellular_alt</i>';
            break;
        case 3:
            fanSpeedDisplay.innerHTML = '<i class="material-icons-outlined">hdr_auto</i>';
            break;
        default:
            fanSpeedDisplay.innerHTML = '<i class="material-icons-outlined">error</i>'; // Fallback icon
            break;
    }

    const swingBtn = document.getElementById('swing-button');
    swingBtn.classList.toggle('swing-off', settings.swing !== 1);
    swingBtn.classList.toggle('swing-on', settings.swing === 1);

    document.getElementById('tempDisplay').innerHTML = settings.temp+"°C";
}

function togglePower() {
    fetch('/update', {
        method: 'POST',
        body: "POWER",
    })
    .then(response => {
        if (!response.ok) {
            throw new Error('Network response was not ok');
        }
        return response;
    })
    .then(data => {
        console.log('Success:', data);
        fetchSettings();
    })
    .catch((error) => {
        console.error('Error:', error);
    });
}

function changeFanSpeed(delta) {
    const command = delta > 0 ? "FAN_UP" : "FAN_DOWN";

    fetch('/update', {
        method: 'POST',
        body: command,
    })
    .then(response => {
        if (!response.ok) {
            throw new Error('Network response was not ok');
        }

        return response;
    })
    .then(data => {
        console.log('Success:', data);

        fetchSettings();
    })
    .catch((error) => {
        console.error('Error:', error);
    });
}

function changeTemperature(delta) {
    const command = delta > 0 ? "TEMP_UP" : "TEMP_DOWN";

    fetch('/update', {
        method: 'POST',
        body: command,
    })
    .then(response => {
        if (!response.ok) {
            throw new Error('Network response was not ok');
        }

        return response;
    })
    .then(data => {
        console.log('Success:', data);

        fetchSettings();
    })
    .catch((error) => {
        console.error('Error:', error);
    });
}

function toggleSwing() {
    fetch('/update', {
        method: 'POST',
        body: "SWING",
    })
    .then(response => {
        if (!response.ok) {
            throw new Error('Network response was not ok');
        }

        return response;
    })
    .then(data => {
        console.log('Success:', data);
        fetchSettings();
    })
    .catch((error) => {
        console.error('Error:', error);
    });
}

function changeMode(mode) {
    fetch('/update', {
        method: 'POST',
        body: mode,
    })
    .then(response => {
        if (!response.ok) {
            throw new Error('Network response was not ok');
        }

        return response;
    })
    .then(data => {
        console.log('Success:', data);
        fetchSettings();
    })
    .catch((error) => {
        console.error('Error:', error);
    });
}
