; -----------------------------------------------------------------------------
; b_k -- BareMetal Linux syscall API for k
global b_k
b_k:
	cmp ax, 0
	je b_k_read
	cmp ax, 1
	je b_k_write
	cmp ax, 2
	je b_k_open
	cmp ax, 3
	je b_k_close
	cmp ax, 4
	je b_k_stat
	int3 ; BP exception
b_k_read:
	cmp rdi, 0
	je b_k_read_stdin
	int3 ; BP exception
b_k_read_stdin: ; Read up to RDX bytes and store at starting address in RSI, return bytes read in RAX
	push rdx
	push rdi
	mov rdi, rsi
	call [0x00100010]
	mov rax, rcx ; b_input ; Number of bytes read
	pop rdi
	pop rdx
	ret
b_k_write:
	cmp rdi, 1
	je b_k_write_stdout
	cmp rdi, 2
	je b_k_write_stderr
	int3 ; BP exception
b_k_write_stdout:
b_k_write_stderr:
	push rcx
	mov rcx, rdx
	call [0x00100018] ; b_output
	pop rcx
	mov rax, rdx
	ret
b_k_open:
b_k_close:
b_k_stat:
	int3 ; BP exception
;-----------------------------------------------------------------------------
