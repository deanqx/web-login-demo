<script lang="ts" module>
	let id_counter = 0;
</script>

<script lang="ts">
	let {
		gclass = '',
		value = $bindable(''),
		label,
		placeholder = '',
		type = 'text',
		readonly = false
	}: {
		gclass?: string;
		value?: string;
		label: string;
		placeholder?: string;
		type?: string;
		readonly?: boolean;
	} = $props();

	let id = 'input_' + id_counter++;
</script>

<dl class="form-group {gclass}">
	<dt class="input_label">
		<label for={`input_label_${id}`}>
			{label}
		</label>
	</dt>
	<dd>
		<input {id} class="input_field" {value} {placeholder} {type} {readonly} />
	</dd>
</dl>

<style lang="scss">
	dl {
		max-width: $input_field_x;
		width: 100%;
	}

	:global(.input_label) {
		margin-bottom: 0.1rem;
		font-weight: 600;
		cursor: default;
	}

	dd {
		margin: 0;
	}

	:global(.input_field) {
		box-sizing: border-box;
		max-width: $input_field_x;
		width: 100%;
		display: block;
		height: $button_y;
		border: 1px solid black;
		border-radius: $border_radius;
		padding: $button_padding_y 10px;
	}

	:global(.input_field):focus {
		outline: 2px solid $focused_outline;
		border-color: transparent;
	}

	:global(.input_field):read-only {
		background-color: $button_hover;
	}

	:global(.input_field):read-only:focus {
		outline: none;
		border-color: black;
	}
</style>
