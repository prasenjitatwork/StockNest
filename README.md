# Aaravi's Yum Box — Stockroom

A small, dependency-free inventory and business snapshot app built from the supplied workbook.

## Open the app

Start the included local web server in PowerShell:

```powershell
powershell -ExecutionPolicy Bypass -File .\run-app.ps1
```

Then open [http://localhost:8765](http://localhost:8765). Keep the PowerShell window open while using the app.

## Publish on PHP hosting

The local PowerShell server is only for running the app on your own computer. For the hosted site, the frontend uses `api.php`; it needs PHP 7.4 or newer with the cURL extension enabled, HTTPS, and PHP write access to `App_Data`.

1. Upload the app files, `api.php`, `oauth-callback.php`, `App_Data/google-oauth.example.php`, `App_Data/web.config`, and `App_Data/.htaccess` to the website root. Keep any hosting-provider `web.config` at the root unchanged. The access-control files inside `App_Data` protect the OAuth configuration and server-side session files.
2. In `App_Data`, copy `google-oauth.example.php` to `google-oauth.php`. Edit the copy in the hosting file manager: enter your Google Web OAuth client secret and set `app_base_url` to `https://aaravisumbx.themidatouche.com` (or your site's HTTPS origin). Never commit or share `google-oauth.php`.
3. In Google Cloud Console, add the hosted site origin under **Authorized JavaScript origins** and add `https://aaravisumbx.themidatouche.com/oauth-callback.php` under **Authorized redirect URIs**. Keep the localhost entries too if you also use the local app.
4. Reload the hosted site. Sign in with Google, then enter the Google Sheet link. If sign-in fails, check that PHP cURL is enabled and that the PHP process can create/write `App_Data/yum-box-sessions`.

## Sign in and connect your Google Sheet

1. In Google Cloud Console, enable the Google Sheets API and configure the OAuth consent screen. For a Gmail account, set the audience to **External**. While the app is in **Testing**, add the Google account you will sign in with under **Test users**.
2. Create an OAuth client ID of type **Web application**. For local use, add `http://localhost:8765` under **Authorized JavaScript origins** and `http://localhost:8765/oauth/callback` under **Authorized redirect URIs**. For hosted use, also follow the hosted redirect URI setup above.
3. Keep the public client ID in `google-config.js`. In PowerShell, run `powershell -ExecutionPolicy Bypass -File .\configure-google.ps1` and enter the Web application's client secret at its hidden prompt. It is encrypted for your Windows account and stored outside the app folder; never put it in browser code or share it in chat.
4. Start `run-app.ps1` and open [http://localhost:8765](http://localhost:8765). Choose **Sign in with Google**, then authorize the account that can edit the workbook.
5. On first use, paste your Google Sheet link and choose **Open my sheet**. The dashboard appears only after the sheet loads successfully.

Google redirects back to the app after sign-in. The local server holds refresh tokens in memory; hosted PHP stores them in server-side session files under `App_Data`. Both use an HttpOnly session cookie for up to one day; after a browser refresh, the app loads the sheet again from Google without an additional sign-in. **Log out** revokes the Google token and ends the session immediately. On local use, restarting the PowerShell server clears sessions; hosted session files are managed by PHP.

If Google shows **Error 401: invalid_client** or **no registered origin**, open the OAuth client matching the ID in `google-config.js` and check that the correct localhost or hosted origin and redirect URI are registered. Save the change, wait a few minutes, and reload the app.

If Google shows **Error 403: access_denied** saying the app has not completed verification, check **Google Auth Platform → Audience → Test users** and add the exact account selected in the sign-in prompt. Save, then retry and accept the unverified-app warning if Google displays one. Public use beyond test users requires completing Google's verification for the Sheets scope.

The app uses the Google Sheets API through its local or hosted server. Google sign-in requests the `spreadsheets` scope, which lets this app read and edit spreadsheets available to the authorizing account; app requests target only the configured spreadsheet. The app does not share the workbook with another person. If the sheet is currently shared as "Anyone with the link", set **General access** to **Restricted** in Google Sheets to stop other link holders from reading it; OAuth does not change the sheet's existing sharing settings.

Inventory, purchases, stock movements, payouts, and expenses are read from and written directly to Google Sheets. The app does not bundle a local workbook copy, save workbook data or OAuth tokens in browser storage, or provide offline mode. Only the selected sheet link is saved in this browser. OAuth tokens stay on the server; after one day, sign in again.

## What’s included

- Searchable inventory with low-stock and out-of-stock indicators.
- Stock adjustments that prevent stock from going below zero.
- Purchase entry that updates stock, purchase totals, and movement history together.
- Platform payout and operating expense entry, with a live profit-and-loss summary.
- Use Google Sheets' **File → Make a copy** or **Download** options to back up workbook data.

Stock adjustments, new items, purchases, payouts, and expenses are written to their corresponding workbook tabs. The workbook's revenue summary includes a payout that its log marks as pending; the app calls this out in the finance view.
