<script lang="ts">
    import InputField from '$lib/InputField.svelte'

    let remember = $state(false)

    let username = $state('')
    let password = $state('')
    let response_message = $state('')

    async function handle_submit(event: Event) {
        event.preventDefault() // Prevent form from refreshing the page

        try {
            const response = await fetch('/api/login', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ username, password })
            })

            const result = await response.json()

            if (response.ok) {
                response_message = ''

                let now_ms = new Date().getTime()

                // Expires in 365 days
                let expires_date = new Date(now_ms + 356 * 24 * 60 * 60 * 1000)

                document.cookie =
                    'session_key=' +
                    result.session_key +
                    '; expires=' +
                    expires_date.toUTCString() +
                    '; path=/; SameSite=Strict'

                return
            }

            response_message = result.message
        } catch (error: unknown) {
            if (error instanceof Error) {
                response_message = `Verbingdung zum Server fehlgeschlagen: ${error.message}`
            } else {
                throw error
            }
        }
    }
</script>

<div class="login_centered_container">
    <div class="login_container">
        <div class="login_header">
            <h1 class="h1">Login</h1>
        </div>
        <form onsubmit={handle_submit}>
            <InputField bind:value={username} label="Nutzername" />
            <InputField
                bind:value={password}
                label="Passwort"
                type="password"
            />
            <div class="remember">
                <label class="select-none">
                    <input type="checkbox" bind:checked={remember} />
                    Angemeldet bleiben
                </label>
            </div>
            <button class="btn btn-primary w-full" type="submit"
                >Einloggen</button
            >
        </form>
        <div class="forgot">
            <a href="/">Passwort vergessen?</a>
            <p>{response_message}</p>
        </div>
    </div>
</div>

<style lang="scss">
    :global(.login_centered_container) {
        display: flex;
        justify-content: center;
        align-items: center;
        min-height: 100vh;
    }

    :global(.login_container) {
        display: flex;
        flex-direction: column;
        background: $background;
        padding: 40px;
        border-radius: 20px;
        border: 1px solid $border;
        box-sizing: border-box;
        width: 100vw;
        max-width: 400px;
        margin: 0 8px;
    }

    :global(.login_header) {
        display: flex;
        justify-content: space-between;
    }

    .remember {
        margin-bottom: 20px;
    }

    .remember input {
        accent-color: $primary;
        cursor: pointer;
    }

    .forgot {
        margin-top: 10px;
    }

    .forgot a {
        display: block;
        text-align: center;
    }
</style>
