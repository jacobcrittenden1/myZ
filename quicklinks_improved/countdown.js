// countdown.js
function calculateBusinessDays() {
    const selectedDate = new Date("2025-04-30"); // Hardcoded future date
    const today = new Date();

    if (selectedDate <= today) {
        document.getElementById('result').innerText = "The chosen date must be in the future.";
        return;
    }

    let businessDays = 0;
    let currentDate = new Date(today);

    while (currentDate < selectedDate) {
        currentDate.setDate(currentDate.getDate() + 1);
        const dayOfWeek = currentDate.getDay();
        if (dayOfWeek !== 0 && dayOfWeek !== 6) { // Skip Sundays (0) and Saturdays (6)
            businessDays++;
        }
    }

    document.getElementById('result').innerText = `Business days until April 30, 2025: ${businessDays}`;
}
