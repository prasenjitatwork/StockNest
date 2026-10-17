# Aaravi's Yum Box — Stockroom

A small, dependency-free inventory and business snapshot app built from the supplied workbook.

## Open the app

Start the included local web server in PowerShell:

```powershell
powershell -ExecutionPolicy Bypass -File .\run-app.ps1
```

Then open [http://localhost:8765](http://localhost:8765). Keep the PowerShell window open while using the app.

## Sign in and connect your Google Sheet

1. In Google Cloud Console, enable the Google Sheets API and configure the OAuth consent screen. For a Gmail account, set the audience to **External**. While the app is in **Testing**, add the Google account you will sign in with under **Test users**.
2. Create an OAuth client ID of type **Web application**. Add `http://localhost:8765` under **Authorized JavaScript origins** and `http://localhost:8765/oauth/callback` under **Authorized redirect URIs**.
3. Keep the public client ID in `google-config.js`. In PowerShell, run `powershell -ExecutionPolicy Bypass -File .\configure-google.ps1` and enter the Web application's client secret at its hidden prompt. It is encrypted for your Windows account and stored outside the app folder; never put it in browser code or share it in chat.
4. Start `run-app.ps1` and open [http://localhost:8765](http://localhost:8765). Choose **Sign in with Google**, then authorize the account that can edit the workbook.
5. On first use, paste your Google Sheet link and choose **Open my sheet**. The dashboard appears only after the sheet loads successfully.

Google redirects back to the local app after sign-in. The local server holds refresh tokens and maintains an HttpOnly session cookie for up to one day; after a browser refresh, the app loads the sheet again from Google without an additional sign-in. **Log out** revokes the Google token and ends the session immediately. Keep the PowerShell server running; restarting it clears active sessions, so sign in again.

If Google shows **Error 401: invalid_client** or **no registered origin**, open the OAuth client matching the ID in `google-config.js` and add `http://localhost:8765` under **Authorized JavaScript origins**. Save the change, wait a few minutes, and reload the app.

If Google shows **Error 403: access_denied** saying the app has not completed verification, check **Google Auth Platform → Audience → Test users** and add the exact account selected in the sign-in prompt. Save, then retry and accept the unverified-app warning if Google displays one. Public use beyond test users requires completing Google's verification for the Sheets scope.

The app uses the Google Sheets API through its local server. Google sign-in requests the `spreadsheets` scope, which lets this app read and edit spreadsheets available to the authorizing account; app requests target only the configured spreadsheet. The app does not share the workbook with another person. If the sheet is currently shared as "Anyone with the link", set **General access** to **Restricted** in Google Sheets to stop other link holders from reading it; OAuth does not change the sheet's existing sharing settings.

Inventory, purchases, stock movements, payouts, and expenses are read from and written directly to Google Sheets. The app does not bundle a local workbook copy, save workbook data or OAuth tokens in browser storage, or provide offline mode. Only the selected sheet link is saved in this browser. OAuth tokens stay in the local server's memory; after one day or a server restart, sign in again.

## What’s included

- Searchable inventory with low-stock and out-of-stock indicators.
- Stock adjustments that prevent stock from going below zero.
- Purchase entry that updates stock, purchase totals, and movement history together.
- Platform payout and operating expense entry, with a live profit-and-loss summary.
- Use Google Sheets' **File → Make a copy** or **Download** options to back up workbook data.

Stock adjustments, new items, purchases, payouts, and expenses are written to their corresponding workbook tabs. The workbook's revenue summary includes a payout that its log marks as pending; the app calls this out in the finance view.
