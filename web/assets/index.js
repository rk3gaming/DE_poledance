let currentDance = 1;

window.addEventListener('message', (event) => {
    const data = event.data;
    
    if (data.type === 'show') {
        document.getElementById('stripUI').style.display = 'block';
        updateDanceNumber(data.danceNumber || 1);
    } else if (data.type === 'hide') {
        document.getElementById('stripUI').style.display = 'none';
    } else if (data.type === 'updateDance') {
        updateDanceNumber(data.danceNumber);
    }
});

document.addEventListener('keyup', (event) => {
    if (event.key === 'x' || event.key === 'X') {
        fetch(`https://${GetParentResourceName()}/stopStrip`, {
            method: 'POST'
        });
    }
});

function updateDanceNumber(number) {
    currentDance = number;
    document.getElementById('currentDance').textContent = number;
}

document.getElementById('prevDance').addEventListener('click', () => {
    fetch(`https://${GetParentResourceName()}/changeDance`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            direction: 'prev'
        })
    });
});

document.getElementById('nextDance').addEventListener('click', () => {
    fetch(`https://${GetParentResourceName()}/changeDance`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            direction: 'next'
        })
    });
});
