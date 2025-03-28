<script setup>

import { ref, onMounted } from 'vue'

const message = ref('')
const inputString = ref('');
const inputValue = ref(0);
const responseData = ref([]);
const mode = ref(0);
onMounted(async () => {
  const response = await fetch('https://flaskapiintuitive4.vercel.app/api/hello')
  const data = await response.json()
  message.value = data.message
})
const setMode = (selectedMode) => {
  mode.value = selectedMode;
  inputString.value = '';
  responseData.value = [];
};

//formatando o valor gasto
const formatReal = (value) => {
  return new Intl.NumberFormat('pt-BR', {
    style: 'currency',
    currency: 'BRL'
  }).format(value);
};
const sendData = async () => {
  let url;
  // separando url de acordo com o modo de relevância escolhido
  if (mode.value === 1) {
    url = `https://flaskapiintuitive4.vercel.app/busca?q=${encodeURIComponent(inputString.value)}&quant=${inputValue.value}`;
  } else if (mode.value === 2) {
    url = `https://flaskapiintuitive4.vercel.app/busca?nome=${encodeURIComponent(inputString.value)}&quant=${inputValue.value}`;
  } else {
    return;
  }
  const response = await fetch(url, {
    method: 'GET',
    headers: {
      'Content-Type': 'application/json',
    },
  });

  if (!response.ok) return;

  const rawData = await response.json();
  console.log(rawData);
  if (mode.value == 1) {
  responseData.value = rawData.Gasto.map((gasto, index) => ({
    Gasto: gasto,
    Nome_Fantasia: rawData.Nome_Fantasia[index],
    Registro_ANS: rawData.Registro_ANS[index]
  }));
  }
  if (mode.value == 2) {
    responseData.value = rawData.Registro_ANS.map((registro, index) => ({
      Registro_ANS: registro,
      Nome_Fantasia: rawData.Nome_Fantasia[index],
      Data_Registro_ANS: rawData.Data_Registro_ANS[index]
    }));
  }
  
};
</script>
<!-- Utilizando tailwind pois acho que ela mantém o trabalho mais limpo e concreto -->
<template >
  <div class = "bg-gray-100 h-lvh w-lvw flex p-5 flex-col justify-center items-center">
    <div class = "h-[200px] w-[600px] mb-12">
      <hi class = "text-2xl font-bold py-5 text-center  flex justify-center text-gray-950">Teste 4 Intuitive Care</hi>
      <p class = " text-justify pt-5 font-normal text-gray-900">Fiquei em dúvida sobre quais critérios considerar mais relevantes para exibir os resultados.
         Por isso, criei dois modos de pesquisa: <strong>um baseado no gasto total no último trimestre de 2024 associado à descrição</strong> e outro
          que <strong>ordena os resultados pela data de registro, utilizando o nome da empresa e exibindo as mais antigas primeiro.</strong>
      </p>
    </div>
    <div class="flex space-x-5 mb-4">
      <button 
        @click="setMode(1)"
        class="rounded-2xl bg-indigo-500/90 h-16 p-2 text-gray-50 hover:bg-indigo-400 duration-300"
        :class="{'bg-indigo-700': mode === 1}"
      >
        Relevância por gasto e descrição
      </button>
      <button 
        @click="setMode(2)"
        class="rounded-2xl bg-indigo-500 h-16 p-2 text-gray-50 hover:bg-indigo-400 duration-300"
        :class="{'bg-indigo-700': mode === 2}"
      >
        Relevância por nome e data
      </button>
    </div>
    <div v-if="mode === 1" class="flex items-end space-x-3 mb-4">
        <div class="flex-1">
          <input 
            v-model="inputString" 
            placeholder="Digite a descrição" 
            class="border rounded h-10 px-2 py-2"
          />
        </div>
        <div class="flex-1 flex flex-col">
          <label class="text-sm text-center mb-1">Quantidade de valores</label>
          <select 
            v-model="inputValue" 
            class="border h-10 rounded px-2 py-2 "
          >
            <option disabled value="">Selecione</option>
            <option value="3">3</option>
            <option value="5">5</option>
            <option value="10">10</option>
            <option value="15">15</option>
            <option value="20">20</option>
          </select>
        </div>
      
      
      <button 
        class="bg-indigo-500 hover:bg-indigo-700 text-white font-bold py-2 px-4 rounded" 
        @click="sendData"
      >
        Buscar
      </button>
    </div>

      <div v-if="mode === 2" class="flex items-end space-x-3 mb-4">
        <div class="flex-1">
          <input 
            v-model="inputString" 
            placeholder="Digite o nome fantasia" 
            class="border rounded h-10 px-2 py-2 "
          />
        </div>
        <div class="flex-1 flex flex-col">
          <label class="text-sm text-center mb-1">Quantidade de valores</label>
          <select 
            v-model="inputValue" 
            class="border h-10 rounded px-2 py-2 "
          >
            <option disabled value="">Selecione</option>
            <option value="3">3</option>
            <option value="5">5</option>
            <option value="10">10</option>
            <option value="15">15</option>
            <option value="20">20</option>
          </select>
        </div>
      
      
      <button 
        class="bg-indigo-500 hover:bg-indigo-700 text-white font-bold py-2 px-4 rounded" 
        @click="sendData"
      >
        Buscar
      </button>
    </div>
    
    <div class = "overflow-y-auto max-h-[500px]">
      <p v-if="responseData.length === 0 " class = "text-md text-center">Nenhum resultado escolhido/encontrado</p>
      <table v-if="responseData.length && mode === 1" class="mt-4">
        <thead>
          <tr>
            <th class="px-4 py-2">Gasto</th>
            <th class="px-4 py-2">Nome Fantasia</th>
            <th class="px-4 py-2">Registro ANS</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(item, index) in responseData" :key="index" class = "overflow-y-auto max-h-full">
            <td class="px-4 py-2 border text-center">{{ formatReal(item.Gasto) }}</td>
            <td class="px-4 py-2 border text-center">{{ item.Nome_Fantasia }}</td>
            <td class="px-4 py-2 border text-center">{{ item.Registro_ANS }}</td>
          </tr>
          
        </tbody>
      </table>
      
      <table v-if="mode === 2 && responseData.length" class="mt-4">

        <thead>
          <tr>
            <th class="px-4 py-2">Registro</th>
            <th class="px-4 py-2">Nome Fantasia</th>
            <th class="px-4 py-2">Data de Registro</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(item, index) in responseData" :key="'mode2-'+index" class = "overflow-y-auto max-h-full">
            <td class="px-4 py-2 border text-center">{{ item.Registro_ANS }}</td>
            <td class="px-4 py-2 border text-center">{{ item.Nome_Fantasia }}</td>
            <td class="px-4 py-2 border text-center">{{ item.Data_Registro_ANS }}</td>
          </tr>
        </tbody>
      </table>
    </div>
    
  </div>
</template>
