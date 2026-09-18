<script lang="ts">
  import { onMount } from 'svelte';
  import * as XLSX from 'xlsx';
  // TODO: Import pocketbase instance
  
  let pendingRows: Array<{
    id: string;
    date: string;
    desc: string;
    amount: number;
    type: string;
    suggestion_mod: string;
    suggestion_cat: string;
    raw: any;
  }> = [];
  
  let isLoading = false;
  let fileInput: HTMLInputElement;

  function handleFileUpload(event: Event) {
    const target = event.target as HTMLInputElement;
    const file = target.files?.[0];
    if (!file) return;

    isLoading = true;
    
    const reader = new FileReader();
    reader.onload = (e) => {
      try {
        const data = new Uint8Array(e.target?.result as ArrayBuffer);
        const workbook = XLSX.read(data, { type: 'array' });
        
        // Pega na primeira folha (sheet) do Excel
        const firstSheetName = workbook.SheetNames[0];
        const worksheet = workbook.Sheets[firstSheetName];
        
        // Converte para JSON
        const rawRows = XLSX.utils.sheet_to_json(worksheet, { defval: "" });
        
        const rows = rawRows.map((row: any, index) => {
          // Extrair as colunas mais comuns. Isto pode ser aperfeiçoado perante o formato real do teu banco.
          const dateStr = row.Data || row.Date || row.data || new Date().toLocaleDateString();
          const descStr = row.Descricao || row.Descrição || row.Description || JSON.stringify(row);
          const amountVal = row.Valor || row.Montante || row.Amount || 0;
          
          let amount = 0;
          if (typeof amountVal === 'number') {
            amount = amountVal;
          } else if (typeof amountVal === 'string') {
            amount = parseFloat(amountVal.replace(',', '.'));
          }
          
          return {
            id: `row-${Date.now()}-${index}`,
            date: dateStr,
            desc: descStr,
            amount: amount || 0,
            type: amount >= 0 ? "Receita" : "Despesa",
            suggestion_mod: "Família",
            suggestion_cat: "Por Categorizar",
            raw: row
          };
        });
        
        pendingRows = [...pendingRows, ...rows];
        isLoading = false;
        
        // Reset file input
        if (fileInput) fileInput.value = '';
      } catch (error) {
        console.error("Erro a processar o ficheiro Excel:", error);
        alert("Ocorreu um erro ao ler o ficheiro Excel.");
        isLoading = false;
      }
    };
    reader.readAsArrayBuffer(file);
  }
  
  function approveRow(id: string) {
    // Lógica para enviar para o PocketBase
    console.log("Approving row", id);
    pendingRows = pendingRows.filter(row => row.id !== id);
  }
  
  function rejectRow(id: string) {
    pendingRows = pendingRows.filter(row => row.id !== id);
  }
  
  function approveAll() {
    console.log("Approving all rows");
    pendingRows = [];
  }
</script>

<div class="space-y-6">
  <div class="flex justify-between items-center mb-6">
    <h2 class="text-2xl font-bold text-slate-800 tracking-tight">Validação de Extrato</h2>
    
    <div>
      <input 
        type="file" 
        accept=".xls,.xlsx,.csv" 
        class="hidden" 
        bind:this={fileInput} 
        on:change={handleFileUpload}
      />
      <button 
        on:click={() => fileInput.click()}
        class="bg-slate-800 text-white px-4 py-2 rounded-xl text-sm font-medium hover:bg-slate-700 transition-colors shadow-sm flex items-center gap-2"
        disabled={isLoading}
      >
        {#if isLoading}
          <svg class="animate-spin h-4 w-4 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24"><circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle><path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path></svg>
          Processando...
        {:else}
          + Fazer Upload Extrato (XLS/XLSX)
        {/if}
      </button>
    </div>
  </div>

  {#if pendingRows.length === 0}
    <div class="bg-white rounded-2xl border border-slate-200 p-12 text-center shadow-sm">
      <svg xmlns="http://www.w3.org/2000/svg" class="h-12 w-12 text-slate-300 mx-auto mb-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
      </svg>
      <h3 class="text-lg font-medium text-slate-900 mb-1">Nenhum registo pendente</h3>
      <p class="text-sm text-slate-500">Faz o upload de um extrato bancário para começar a categorizar.</p>
    </div>
  {:else}
    <div class="bg-white rounded-2xl shadow-sm border border-slate-200 overflow-hidden">
      <div class="p-4 border-b border-slate-200 bg-slate-50 flex items-center justify-between">
        <span class="text-sm font-medium text-slate-600">{pendingRows.length} registos pendentes de validação</span>
        <button on:click={approveAll} class="text-emerald-600 text-sm font-medium hover:text-emerald-700 transition-colors">Aprovar Todos</button>
      </div>

      <!-- Desktop Table View -->
      <div class="hidden md:block overflow-x-auto">
        <table class="w-full text-left border-collapse">
          <thead>
            <tr class="bg-white border-b border-slate-100 text-xs uppercase text-slate-500">
              <th class="p-4 font-semibold">Data</th>
              <th class="p-4 font-semibold">Descrição</th>
              <th class="p-4 font-semibold">Valor</th>
              <th class="p-4 font-semibold">Módulo</th>
              <th class="p-4 font-semibold">Categoria</th>
              <th class="p-4 font-semibold text-right">Ação</th>
            </tr>
          </thead>
          <tbody class="divide-y divide-slate-100">
            {#each pendingRows as row (row.id)}
              <tr class="hover:bg-slate-50 transition-colors group">
                <td class="p-4 text-sm text-slate-600 font-medium whitespace-nowrap">{row.date}</td>
                <td class="p-4 text-sm text-slate-900 font-medium">{row.desc}</td>
                <td class="p-4 text-sm font-bold whitespace-nowrap">
                  <span class={row.amount > 0 ? 'text-emerald-600' : 'text-slate-700'}>
                    {row.amount > 0 ? '+' : ''}{row.amount.toFixed(2).replace('.', ',')} €
                  </span>
                </td>
                <td class="p-4">
                  <select bind:value={row.suggestion_mod} class="text-sm border-slate-200 rounded-lg bg-slate-50 text-slate-700 py-1.5 px-3 focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500 outline-none cursor-pointer">
                    <option value="Família">Família</option>
                    <option value="Arrendamento">Arrendamento</option>
                    <option value="Projeto">Projeto "I Love Paul..."</option>
                  </select>
                </td>
                <td class="p-4">
                  <input type="text" bind:value={row.suggestion_cat} class="text-sm border border-slate-200 rounded-lg bg-white text-slate-700 py-1.5 px-3 w-32 focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500 outline-none" />
                </td>
                <td class="p-4 text-right">
                  <div class="flex items-center justify-end gap-2">
                    <button on:click={() => rejectRow(row.id)} class="w-8 h-8 rounded-full bg-rose-50 text-rose-500 flex items-center justify-center hover:bg-rose-100 hover:text-rose-600 transition-colors" title="Rejeitar">
                      <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd" /></svg>
                    </button>
                    <button on:click={() => approveRow(row.id)} class="w-8 h-8 rounded-full bg-emerald-500 text-white flex items-center justify-center hover:bg-emerald-600 shadow-sm transition-colors" title="Aprovar">
                      <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd" /></svg>
                    </button>
                  </div>
                </td>
              </tr>
            {/each}
          </tbody>
        </table>
      </div>

      <!-- Mobile Card View -->
      <div class="md:hidden divide-y divide-slate-100">
        {#each pendingRows as row (row.id)}
          <div class="p-4 space-y-3">
            <div class="flex justify-between items-start">
              <div>
                <p class="text-sm font-medium text-slate-500">{row.date}</p>
                <p class="font-semibold text-slate-900 leading-tight mt-0.5">{row.desc}</p>
              </div>
              <p class={`font-bold ${row.amount > 0 ? 'text-emerald-600' : 'text-slate-800'}`}>
                {row.amount > 0 ? '+' : ''}{row.amount.toFixed(2).replace('.', ',')} €
              </p>
            </div>
            
            <div class="grid grid-cols-2 gap-2">
              <select bind:value={row.suggestion_mod} class="w-full text-xs border-slate-200 rounded-lg bg-slate-50 text-slate-700 py-2 px-2 focus:ring-2 focus:ring-emerald-500 outline-none">
                <option value="Família">Família</option>
                <option value="Arrendamento">Arrendamento</option>
                <option value="Projeto">Projeto</option>
              </select>
              <input type="text" bind:value={row.suggestion_cat} class="w-full text-xs border border-slate-200 rounded-lg bg-white text-slate-700 py-2 px-2 focus:ring-2 focus:ring-emerald-500 outline-none" placeholder="Categoria" />
            </div>
            
            <div class="flex justify-end gap-2 pt-2 border-t border-slate-100">
              <button on:click={() => rejectRow(row.id)} class="flex-1 py-2 rounded-lg bg-rose-50 text-rose-600 font-medium text-sm hover:bg-rose-100 transition-colors">Rejeitar</button>
              <button on:click={() => approveRow(row.id)} class="flex-1 py-2 rounded-lg bg-emerald-500 text-white font-medium text-sm hover:bg-emerald-600 transition-colors shadow-sm">Aprovar</button>
            </div>
          </div>
        {/each}
      </div>
    </div>
  {/if}
</div>
