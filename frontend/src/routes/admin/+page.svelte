<script lang="ts">
    import InputField from '$lib/InputField.svelte'

    let full_name = $state('')
    let generated_username = $state('')
    let generated_password = $state('')
</script>

<div class="page-content">
    <h1 class="h1">Admin Tool</h1>
    <h2 class="h2">Nutzer erstellen</h2>
    <div class="section-container">
        <form>
            <InputField
                bind:value={full_name}
                label="Vor- und Nachname"
                placeholder="Hans Müller"
            />
            <button class="btn btn-primary self-end">Erstellen</button>
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
