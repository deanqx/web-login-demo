<script lang="ts">
    import InputField from '$lib/InputField.svelte'

    let full_name = $state('')
    let response_message = $state('')
    let generated_username = $state('')
    let generated_password = $state('')

    async function handle_submit(event: Event) {
        event.preventDefault() // Prevent form from refreshing the page

        try {
            const response = await fetch('/api/user', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ full_name })
            })

            const response_body = await response.json()

            if (response.ok) {
                response_message = ''
                generated_username = response_body.generated_username
                generated_password = response_body.generated_password

                return
            } else {
                response_message = response_body.message
                generated_username = ''
                generated_password = ''
            }
        } catch (error: unknown) {
            if (error instanceof Error) {
                response_message = `Verbindung zum Server fehlgeschlagen: ${error.message}`
            } else {
                throw error
            }
        }
    }
</script>

<div class="page-content">
    <h1 class="h1">Admin Tool</h1>
    <h2 class="h2">Nutzer erstellen</h2>
    <div class="section-container">
        <form onsubmit={handle_submit}>
            <InputField
                bind:value={full_name}
                label="Vor- und Nachname"
                placeholder="Hans Müller"
            />
            <button class="btn btn-primary">Erstellen</button>
        </form>
        <div class="split-view">
            <div>
                <InputField
                    bind:value={generated_username}
                    label="Nutzername"
                    readonly={true}
                />
            </div>
            <div>
                <InputField
                    bind:value={generated_password}
                    label="Generiertes Passwort"
                    readonly={true}
                />
            </div>
        </div>
    </div>
</div>

<style lang="scss">
</style>
