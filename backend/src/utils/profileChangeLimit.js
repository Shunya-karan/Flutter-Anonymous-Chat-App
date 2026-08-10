const CHANGE_LIMIT = 2;
const WINDOW_MS = 24 * 60 * 60 * 1000;

function getRecentChanges(changeDates = []) {
  const now = Date.now();

  return changeDates.filter(
    date =>
      now - new Date(date).getTime() < WINDOW_MS
  );
}

function checkChangeLimit(changeDates = []) {
  const recentChanges = getRecentChanges(changeDates);

  if (recentChanges.length >= CHANGE_LIMIT) {
    const oldestChange = new Date(
      recentChanges[0]
    ).getTime();

    const retryAfter = Math.ceil(
      (oldestChange + WINDOW_MS - Date.now()) / 1000
    );

    return {
      allowed: false,
      recentChanges,
      retryAfter,
    };
  }

  return {
    allowed: true,
    recentChanges,
    retryAfter: 0,
  };
}

module.exports = {
  checkChangeLimit,
};