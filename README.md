<h1>📱 Currency Tracker</h1>
<p>
  A iOS expense tracker that supports multi-currency transactions with real-time USD → INR conversion, offline mode, and beautiful category charts.
</p>

<hr />

<h2>🚀 Features</h2>
<ul>
  <li><strong>Live Exchange Rate</strong>: Fetches USD → INR rates from
    <a href="https://exchangeratesapi.io/" target="_blank" rel="noopener noreferrer">exchangeratesapi.io</a>.
  </li>
  <li><strong>15-Minute Persistent Cache</strong>: Stores exchange rate and fetch time in
    <code>UserDefaults</code> to reduce API calls, even after app restart.
  </li>
  <li><strong>Offline Mode</strong>:
    <ul>
      <li>INR transactions work offline immediately.</li>
      <li>USD transactions show “Waiting for internet connection to convert” until updated.</li>
    </ul>
  </li>
  <li><strong>Transaction Validation</strong>: Prevents zero or negative amounts, enforces numeric input, and limits descriptions to 100 characters.</li>
  <li><strong>Modern Summary UI</strong>:
    <ul>
      <li>Total spend &amp; transaction count</li>
      <li>Donut chart with category breakdown &amp; amounts</li>
      <li>Recent transactions list with clear currency formatting</li>
    </ul>
  </li>
</ul>

<hr />

<h2>🛠 Build &amp; Run Instructions</h2>

<h3>1️⃣ Prerequisites</h3>
<ul>
  <li>macOS with <strong>Xcode 14</strong> or later</li>
  <li>iOS 16+ (Swift Charts support)</li>
</ul>

<h3>2️⃣ Setup Steps</h3>
<ol>
  <li><strong>Clone the repository</strong>
    <pre><code>git clone https://github.com/Roshan-047/Currency_Expense_Tracker
</code></pre>
  </li>
  <li><strong>Open in Xcode</strong>
    <pre><code>open Currency_Expense_Tracker.xcodeproj
</code></pre>
  </li>
  <li><strong>Run the app</strong><br />
    Select an iPhone simulator (e.g., iPhone 16 Pro) and press <strong>Cmd + R</strong> or click ▶️ in Xcode.
  </li>
</ol>

<hr />

<h2>📖 How to Use</h2>

<h3>Adding a Transaction</h3>
<ol>
  <li>Tap the <strong>+</strong> button in the top-right corner of the Summary screen.</li>
  <li>Enter:
    <ul>
      <li>Amount (numeric only)</li>
      <li>Currency (<code>INR</code> or <code>USD</code>)</li>
      <li>Category (<code>Food</code>, <code>Travel</code>, <code>Utilities</code>, <code>Other</code>)</li>
      <li>Optional description (max 100 chars)</li>
    </ul>
  </li>
  <li>Tap <strong>Add</strong>:
    <ul>
      <li>For INR → Adds instantly</li>
      <li>For USD → Converts immediately if online, otherwise marked as <em>“Waiting for internet connection to convert”</em></li>
    </ul>
  </li>
</ol>

<h3>Viewing Summary</h3>
<ul>
  <li>See <strong>total spend</strong>, <strong>transaction count</strong>, and a <strong>donut chart</strong> for categories.</li>
  <li>Scroll down for recent transactions with both original and converted amounts.</li>
</ul>

<hr />

<h2>🗂 Tech Stack</h2>
<ul>
  <li><strong>SwiftUI</strong> for UI</li>
  <li><strong>Core Data</strong> for local storage</li>
  <li><strong>Swift Charts</strong> for category breakdown visualization</li>
  <li><strong>UserDefaults</strong> for persistent caching</li>
  <li><strong>Async/Await</strong> for API calls</li>
</ul>

<hr />

