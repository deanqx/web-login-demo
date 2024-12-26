<script lang="ts">
	import InputField from '$lib/InputField.svelte';

	let remember = $state(false);
</script>

<div class="login_centered_container">
	<div class="login_container">
		<div class="login_header">
			<h1 class="h1">Login</h1>
		</div>
		<form method="POST" action="/api/login">
			<InputField name="username" label="Nutzername" />
			<InputField name="password" label="Passwort" type="password" />
			<div class="remember">
				<label class="select-none">
					<input type="checkbox" bind:checked={remember} />
					Angemeldet bleiben
				</label>
			</div>
			<button class="btn btn-primary w-full" type="submit">Einloggen</button>
		</form>
		<div class="forgot">
			<a href="/">Passwort vergessen?</a>
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
