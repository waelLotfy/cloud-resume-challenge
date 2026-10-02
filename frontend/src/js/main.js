// ============================================================
// Visitor counter: increments the count via the backend API
// every time the page loads, and displays the result.
// ============================================================

// The real, live API Gateway base URL (from `terraform output
// api_endpoint`). Safe to hardcode here - it's a PUBLIC endpoint
// the browser is meant to call directly, unlike a secret key,
// which would never belong in client-side code.
const API_BASE_URL = "https://gbxfq66ns3.execute-api.eu-central-1.amazonaws.com";

// Wait until the page's HTML has fully loaded before touching the DOM -
// otherwise document.getElementById() could run before the <span>
// we're looking for even exists yet.
document.addEventListener("DOMContentLoaded", () => {
  updateVisitorCount();
});

async function updateVisitorCount() {
    // The <span id="visitor-count"> already sitting in index.html's
    // footer - this is where we'll show the real count or a fallback.
    const countElement = document.getElementById("visitor-count");

    try {
        // fetch() defaults to GET, so POST must be set explicitly here -
        // this calls the write-only IncrementVisitorCount Lambda.
        const response = await fetch(`${API_BASE_URL}/visitorCount/increment`, {
            method: "POST",
        });

        // fetch() does NOT throw on 4xx/5xx responses - only on true
        // network failure. We must check response.ok ourselves, or a
        // real API error would be silently treated as a success.
        if (!response.ok) {
            throw new Error(`API responded with status ${response.status}`);
        }

        // The Lambda's body is a JSON STRING (from Python's json.dumps).
        // response.json() parses that string into a real JS object:
        // { visitorCount: <number> }.
        const data = await response.json();

        // Show the real count on the page.
        countElement.textContent = data.visitorCount;

    } catch (error) {
        // Covers: no network, CORS block, non-2xx response, or bad JSON.
        // Log the real reason for our own debugging in the browser
        // console, but show visitors a friendly fallback instead of a
        // broken page or a raw error message - the "graceful degradation"
        // behavior from the Solutions Architect mod, done in JS rather
        // than via CloudFront custom error responses.
        console.error("Could not update visitor count:", error);
        countElement.textContent = "—";

    }
}