<script>
    import { page } from '$app/state'

    let { children } = $props()
</script>

{#if page.url.pathname === '/login'}
    {@render children()}
{:else}
    <div class="content">
        <div class="page-content">
            {@render children()}
        </div>
    </div>
{/if}

<style lang="scss">
</style>
