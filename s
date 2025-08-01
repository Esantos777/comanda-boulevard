<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Comanda Boulevard</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/tailwindcss/2.2.19/tailwind.min.css" rel="stylesheet">
    <style>
        /* Estilos personalizados para aprimorar o Tailwind */
        body {
            font-family: "Inter", sans-serif;
            background-color: #f0f2f5; /* Fundo cinza claro */
        }
        header {
            background-color: #3498db; /* Cabeçalho azul */
            color: #ffffff;
            padding: 1.5rem 0;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
        }
        nav a {
            transition: all 0.3s ease;
            border-radius: 0.5rem; /* Cantos arredondados para links de navegação */
        }
        nav a:hover {
            background-color: #2980b9; /* Azul mais escuro no hover */
            transform: translateY(-2px);
        }
        nav a.active-tab {
            background-color: #2980b9; /* Cor da aba ativa */
            pointer-events: none; /* Desabilita clique na aba ativa */
        }
        .section-content {
            background-color: #ffffff;
            border-radius: 0.75rem; /* Cantos mais arredondados */
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
            margin-bottom: 2rem;
            border: 1px solid #e0e0e0;
        }
        h2, h3 {
            color: #2c3e50; /* Cor de cabeçalho mais escura */
            border-bottom: 2px solid #ecf0f1;
            padding-bottom: 0.75rem;
            margin-bottom: 1.5rem;
        }

        form input, form select {
            border: 1px solid #dcdcdc;
            padding: 0.75rem;
            border-radius: 0.5rem;
            transition: border-color 0.2s ease-in-out, box-shadow 0.2s ease-in-out;
        }
        form input:focus, form select:focus {
            border-color: #3498db;
            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.2);
            outline: none;
        }
        button {
            background-color: #28a745; /* Botão verde */
            color: white;
            border: none;
            border-radius: 0.5rem;
            cursor: pointer;
            transition: background-color 0.3s ease, transform 0.2s ease;
        }
        button:hover {
            background-color: #218838; /* Verde mais escuro no hover */
            transform: translateY(-1px);
        }
        .table {
            background-color: #2ecc71; /* Verde para mesas livres */
            color: white;
            text-align: center;
            border-radius: 0.75rem;
            cursor: pointer;
            font-weight: bold;
            transition: background-color 0.3s ease, transform 0.2s ease;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            position: relative; /* Necessário para posicionamento do botão de edição e remoção */
        }
        .table:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15);
        }
        .table.occupied {
            background-color: #e74c3c; /* Vermelho para mesas ocupadas */
        }
        .table.active {
            border: 3px solid #f39c12; /* Borda laranja para mesa ativa */
            box-shadow: 0 0 15px rgba(243, 156, 18, 0.5);
        }
        .product-item, .order-item, .sale-entry {
            background-color: #f8f9fa; /* Fundo claro para itens da lista */
            border-radius: 0.5rem;
            display: flex;
            flex-direction: column; /* Empilha itens verticalmente no mobile */
            align-items: flex-start; /* Alinha itens ao início */
            border: 1px solid #e9ecef;
        }
        @media (min-width: 640px) {
            .product-item, .order-item, .sale-entry {
                flex-direction: row; /* Layout horizontal em telas maiores para simetria */
                justify-content: space-between;
                align-items: center;
            }
        }
        .product-item button, .order-item button {
            background-color: #f39c12; /* Laranja para botões de ação */
            border-radius: 0.375rem;
            margin-top: 0.5rem; /* Adiciona margem para empilhar botões no mobile */
        }
        @media (min-width: 640px) {
            .product-item button, .order-item button {
                margin-top: 0; /* Remove a margem superior em telas maiores para alinhamento horizontal */
            }
        }
        .order-item > span:first-child {
            width: 100%; /* Garante que o nome ocupe a largura total no mobile */
        }
        .order-item > span:nth-child(2) {
            width: 100%; /* Garante que o preço ocupe a largura total no mobile */
            text-align: right;
        }
        @media (min-width: 640px) {
            .order-item > span:first-child, .order-item > span:nth-child(2) {
                width: auto; /* Largura automática em telas maiores */
            }
        }
        .order-item .flex { /* Garante que os botões de ação permaneçam juntos */
            width: 100%;
            justify-content: flex-end; /* Alinha os botões à direita no mobile */
            margin-top: 0.5rem;
        }
        @media (min-width: 640px) {
             .order-item .flex {
                width: auto;
                margin-top: 0;
            }
        }

        footer {
            background-color: #2c3e50; /* Rodapé azul escuro */
            color: #ffffff;
            border-radius: 0 0 0.75rem 0.75rem;
        }
        .message-box {
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background-color: #ffffff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
            z-index: 1000;
            display: none; /* Escondido por padrão */
            text-align: center;
            border: 1px solid #ccc;
            width: 90%; /* Torna a caixa de mensagem responsiva */
            max-width: 400px; /* Limita a largura máxima */
        }
        .message-box button {
            margin-top: 15px;
            background-color: #3498db;
        }
        .message-box button:hover {
            background-color: #2980b9;
        }

        /* Estilos específicos do Modal */
        .modal {
            display: none; /* Escondido por padrão */
            position: fixed;
            z-index: 1001; /* Mais alto que a caixa de mensagem */
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0,0,0,0.4); /* Preto com opacidade */
            justify-content: center;
            align-items: center;
        }

        .modal-content {
            background-color: #fefefe;
            margin: auto;
            padding: 20px;
            border: 1px solid #888;
            border-radius: 0.75rem;
            width: 90%;
            max-width: 500px;
            box-shadow: 0 4px 8px 0 rgba(0,0,0,0.2),0 6px 20px 0 rgba(0,0,0,0.19);
            animation-name: animatetop;
            animation-duration: 0.4s
        }

        /* Adicionar Animação */
        @-webkit-keyframes animatetop {
            from {top:-300px; opacity:0}
            to {top:0; opacity:1}
        }

        @keyframes animatetop {
            from {top:-300px; opacity:0}
            to {top:0; opacity:1}
        }

        .close-button {
            color: #aaa;
            float: right;
            font-size: 28px;
            font-weight: bold;
        }

        .close-button:hover,
        .close-button:focus {
            color: black;
            text-decoration: none;
            cursor: pointer;
        }
        /* Destacar Valor Total */
        .total-highlight {
            background-color: #e6ffe6; /* Fundo verde claro */
            padding: 0.5rem 1rem;
            border-radius: 0.5rem;
            display: inline-block; /* Garante que o preenchimento e o fundo se apliquem corretamente */
        }
        .order-product-result-item {
            padding: 0.75rem 1rem;
            border-bottom: 1px solid #eee;
            cursor: default; /* Alterado para cursor padrão, pois o item em si não é clicável */
            transition: background-color 0.2s ease;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .order-product-result-item:last-child {
            border-bottom: none;
        }
        .order-product-result-item:hover {
            background-color: #fff; /* Sem efeito de hover no próprio item */
        }

        .edit-table-btn {
            position: absolute;
            top: 5px;
            right: 38px; /* Ajustado para dar espaço ao botão de remover */
            background-color: rgba(255, 255, 255, 0.7);
            color: #3498db;
            border-radius: 50%;
            width: 30px;
            height: 30px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1rem;
            font-weight: bold;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
            transition: background-color 0.2s ease, color 0.2s ease;
            z-index: 10;
        }
        .edit-table-btn:hover {
            background-color: #3498db;
            color: #fff;
        }
        .remove-table-btn {
            position: absolute;
            top: 5px;
            right: 5px;
            background-color: rgba(255, 255, 255, 0.7);
            color: #e74c3c; /* Vermelho para o botão de remover */
            border-radius: 50%;
            width: 30px;
            height: 30px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1rem;
            font-weight: bold;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
            transition: background-color 0.2s ease, color 0.2s ease;
            z-index: 10;
        }
        .remove-table-btn:hover {
            background-color: #e74c3c;
            color: #fff;
        }
        .csv-import-section {
            margin-top: 2rem;
            padding-top: 1.5rem;
            border-top: 1px solid #ecf0f1;
        }
        .add-product-list-btn {
            background-color: #6a0dad; /* Uma cor mais distinta para o botão "Adicionar" na lista */
            color: white;
            padding: 0.4rem 0.8rem;
            border-radius: 0.375rem;
            cursor: pointer;
            font-size: 0.75rem;
            transition: background-color 0.2s ease;
            margin-left: 0.5rem; /* Espaço entre o texto e o botão */
        }
        .add-product-list-btn:hover {
            background-color: #4b0082; /* Roxo mais escuro no hover */
        }

        /* Novo Modal de Confirmação */
        .confirmation-modal {
            display: none; /* Escondido por padrão */
            position: fixed;
            z-index: 1002; /* Mais alto que outros modais */
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0,0,0,0.6); /* Fundo mais escuro */
            justify-content: center;
            align-items: center;
        }

        .confirmation-modal-content {
            background-color: #fefefe;
            margin: auto;
            padding: 25px;
            border: 1px solid #888;
            border-radius: 0.75rem;
            width: 90%;
            max-width: 450px;
            box-shadow: 0 4px 8px 0 rgba(0,0,0,0.2),0 6px 20px 0 rgba(0,0,0,0.19);
            text-align: center;
            animation-name: animatetop;
            animation-duration: 0.4s;
        }

        .confirmation-modal-content p {
            margin-bottom: 20px;
            font-size: 1.1rem;
            color: #333;
        }

        .confirmation-modal-content .flex button {
            margin: 0 8px;
            padding: 10px 20px;
            font-size: 1rem;
            border-radius: 0.5rem;
        }
        .confirmation-modal-content .flex button.confirm-yes {
            background-color: #e74c3c; /* Vermelho para Sim */
        }
        .confirmation-modal-content .flex button.confirm-yes:hover {
            background-color: #c0392b;
        }
        .confirmation-modal-content .flex button.confirm-no {
            background-color: #7f8c8d; /* Cinza para Não */
        }
        .confirmation-modal-content .flex button.confirm-no:hover {
            background-color: #5d6d7e;
        }
    </style>
</head>
<body class="min-h-screen flex flex-col">
    <!-- Seção do Cabeçalho -->
    <header class="text-center">
        <h1 class="text-3xl sm:text-4xl font-extrabold mb-4">Comanda Boulevard</h1>
        <nav>
            <ul class="flex flex-col sm:flex-row justify-center space-y-2 sm:space-y-0 sm:space-x-6 px-4">
                <li><a href="#comanda" class="nav-link block px-4 py-2 sm:px-6 sm:py-3 rounded-lg hover:bg-opacity-80 transition-all duration-200">Fazer Comanda</a></li>
                <li><a href="#cadastro" class="nav-link block px-4 py-2 sm:px-6 sm:py-3 rounded-lg hover:bg-opacity-80 transition-all duration-200">Cadastro de Produtos</a></li>
                <li><a href="#relatorio" class="nav-link block px-4 py-2 sm:px-6 sm:py-3 rounded-lg hover:bg-opacity-80 transition-all duration-200">Relatório de Vendas</a></li>
            </ul>
        </nav>
    </header>

    <!-- Área de Conteúdo Principal -->
    <main class="flex-grow p-4 sm:p-5 max-w-4xl mx-auto w-full">
        <!-- Caixa de Mensagens para alertas -->
        <div id="messageBox" class="message-box">
            <p id="messageText"></p>
            <button onclick="document.getElementById('messageBox').style.display='none'">OK</button>
        </div>

        <!-- Seção de Gerenciamento de Comandas (Visualização Padrão) -->
        <section id="comanda" class="section-content content-section p-4 sm:p-6 md:p-8">
            <h2 class="text-xl sm:text-2xl md:text-3xl font-semibold mb-6">Fazer Comanda</h2>
            <div class="tables-container grid grid-cols-2 gap-4 sm:grid-cols-3 sm:gap-6 md:grid-cols-4 lg:grid-cols-5 xl:grid-cols-5">
                <!-- As mesas serão geradas e gerenciadas aqui via JavaScript -->
            </div>
            <div class="flex justify-center mt-6">
                <button id="add-new-table-btn" class="bg-indigo-500 hover:bg-indigo-700 text-white font-bold px-4 py-2 sm:px-5 sm:py-2.5 md:px-6 md:py-3 rounded-lg focus:outline-none focus:shadow-outline transition duration-300 text-sm sm:text-base">Adicionar Mesa</button>
            </div>


            <div id="current-order" class="bg-white p-4 sm:p-6 rounded-lg border border-gray-200 shadow-md mt-8">
                <h3 class="text-lg sm:text-xl md:text-2xl font-semibold mb-4 text-blue-600">Comanda da Mesa <span id="current-table-number" class="font-extrabold text-2xl sm:text-3xl text-blue-800">Nenhuma</span></h3>

                <div class="mb-4 relative"> <!-- Added relative for absolute positioning of results -->
                    <label for="order-product-search" class="block text-gray-700 text-sm font-bold mb-2">Adicionar Produto (digite ou selecione):</label>
                    <input type="text" id="order-product-search" placeholder="Buscar produto..." class="shadow appearance-none border rounded-lg w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline text-sm sm:text-base">
                    <ul id="order-product-results" class="absolute z-10 w-full bg-white border border-gray-300 rounded-lg mt-1 max-h-48 overflow-y-auto shadow-lg hidden">
                        <!-- Os resultados da busca ou a lista completa serão preenchidos aqui -->
                    </ul>
                </div>

                <ul id="order-items" class="space-y-3 mb-6">
                    <!-- Os itens da comanda serão adicionados aqui via JavaScript -->
                    <p id="empty-order-message" class="text-gray-500 italic">Nenhum item nesta comanda.</p>
                </ul>

                <p class="text-lg sm:text-xl font-bold text-gray-800 flex justify-between items-center">
                    Total: <span id="order-total" class="text-green-600 text-2xl sm:text-3xl font-extrabold total-highlight">0.00</span>
                </p>
                <div class="flex justify-end mt-6">
                    <button id="close-order" class="bg-red-500 hover:bg-red-700 text-white font-bold py-2 px-4 rounded-lg focus:outline-none focus:shadow-outline transition duration-300 text-sm sm:text-base">Fechar Comanda</button>
                </div>
            </div>
        </section>

        <!-- Seção de Cadastro de Produtos -->
        <section id="cadastro" class="section-content content-section hidden p-4 sm:p-6 md:p-8">
            <h2 class="text-xl sm:text-2xl md:text-3xl font-semibold mb-6">Cadastro de Produtos</h2>
            <form id="product-form" class="grid grid-cols-1 md:grid-cols-2 gap-4 items-end">
                <div>
                    <label for="product-name" class="block text-gray-700 text-sm font-bold mb-2">Nome do Produto:</label>
                    <input type="text" id="product-name" required class="shadow appearance-none border rounded-lg w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline text-sm sm:text-base">
                </div>
                <div>
                    <label for="product-price" class="block text-gray-700 text-sm font-bold mb-2">Preço (R$):</label>
                    <input type="number" id="product-price" step="0.01" required class="shadow appearance-none border rounded-lg w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline text-sm sm:text-base">
                </div>
                <button type="submit" class="md:col-span-2 bg-blue-500 hover:bg-blue-700 text-white font-bold px-4 py-2 sm:px-5 sm:py-2.5 md:px-6 md:py-3 rounded-lg focus:outline-none focus:shadow-outline transition duration-300 text-sm sm:text-base">Cadastrar Produto</button>
            </form>

            <h3 class="text-lg sm:text-xl md:text-2xl font-semibold mt-8 mb-4">Produtos Cadastrados</h3>
            <div class="mb-4">
                <label for="product-search" class="block text-gray-700 text-sm font-bold mb-2">Pesquisar Produto:</label>
                <input type="text" id="product-search" placeholder="Digite para pesquisar produtos..." class="shadow appearance-none border rounded-lg w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline text-sm sm:text-base">
            </div>
            <ul id="product-list" class="space-y-3">
                <!-- Os produtos serão listados aqui via JavaScript -->
            </ul>

            <div class="csv-import-section">
                <h3 class="text-lg sm:text-xl md:text-2xl font-semibold mb-4">Importar Produtos (CSV)</h3>
                <p class="text-gray-600 text-sm mb-4">
                    Selecione um arquivo CSV com o formato: `Nome do Produto,Preço`. <br>
                    Exemplo: `Refrigerante,5.50`<br>
                    Cada produto em uma nova linha.
                </p>
                <div class="flex flex-col sm:flex-row items-end space-y-3 sm:space-y-0 sm:space-x-3">
                    <input type="file" id="csv-file-input" accept=".csv" class="block w-full text-sm text-gray-900 border border-gray-300 rounded-lg cursor-pointer bg-gray-50 focus:outline-none">
                    <button id="import-csv-btn" class="bg-green-600 hover:bg-green-700 text-white font-bold py-2 px-4 rounded-lg transition duration-300 w-full sm:w-auto text-sm sm:text-base">Importar do CSV</button>
                </div>
            </div>
        </section>

        <!-- Seção de Relatório de Vendas -->
        <section id="relatorio" class="section-content content-section hidden p-4 sm:p-6 md:p-8">
            <h2 class="text-xl sm:text-2xl md:text-3xl font-semibold mb-6">Relatório de Vendas</h2>
            <div id="sales-report-content">
                <!-- O relatório de vendas será gerado aqui via JavaScript -->
                <p class="text-gray-500 italic">Nenhuma venda registrada ainda.</p>
            </div>
        </section>
    </main>

    <!-- Modal de Edição de Produto -->
    <div id="editProductModal" class="modal">
        <div class="modal-content">
            <span class="close-button" onclick="document.getElementById('editProductModal').style.display='none'">&times;</span>
            <h3 class="text-lg sm:text-xl md:text-2xl font-semibold mb-4">Editar Produto</h3>
            <form id="edit-product-form" class="grid grid-cols-1 gap-4">
                <input type="hidden" id="edit-product-id">
                <div>
                    <label for="edit-product-name" class="block text-gray-700 text-sm font-bold mb-2">Nome do Produto:</label>
                    <input type="text" id="edit-product-name" required class="shadow appearance-none border rounded-lg w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline text-sm sm:text-base">
                </div>
                <div>
                    <label for="edit-product-price" class="block text-gray-700 text-sm font-bold mb-2">Preço (R$):</label>
                    <input type="number" id="edit-product-price" step="0.01" required class="shadow appearance-none border rounded-lg w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline text-sm sm:text-base">
                </div>
                <div class="flex justify-end space-x-2 mt-4">
                    <button type="button" onclick="document.getElementById('editProductModal').style.display='none'" class="bg-gray-500 hover:bg-gray-700 text-white font-bold px-4 py-2 sm:px-5 sm:py-2.5 md:px-6 md:py-3 rounded-lg transition duration-300 text-sm sm:text-base">Cancelar</button>
                    <button type="submit" class="bg-green-500 hover:bg-green-700 text-white font-bold px-4 py-2 sm:px-5 sm:py-2.5 md:px-6 md:py-3 rounded-lg transition duration-300 text-sm sm:text-base">Salvar Alterações</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Modal de Edição de Nome da Mesa -->
    <div id="editTableNameModal" class="modal">
        <div class="modal-content">
            <span class="close-button" onclick="document.getElementById('editTableNameModal').style.display='none'">&times;</span>
            <h3 class="text-lg sm:text-xl md:text-2xl font-semibold mb-4">Editar Nome da Mesa</h3>
            <form id="edit-table-name-form" class="grid grid-cols-1 gap-4">
                <input type="hidden" id="edit-table-id">
                <div>
                    <label for="new-table-name" class="block text-gray-700 text-sm font-bold mb-2">Novo Nome da Mesa:</label>
                    <input type="text" id="new-table-name" required class="shadow appearance-none border rounded-lg w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline text-sm sm:text-base">
                </div>
                <div class="flex justify-end space-x-2 mt-4">
                    <button type="button" onclick="document.getElementById('editTableNameModal').style.display='none'" class="bg-gray-500 hover:bg-gray-700 text-white font-bold px-4 py-2 sm:px-5 sm:py-2.5 md:px-6 md:py-3 rounded-lg transition duration-300 text-sm sm:text-base">Cancelar</button>
                    <button type="submit" class="bg-green-500 hover:bg-green-700 text-white font-bold px-4 py-2 sm:px-5 sm:py-2.5 md:px-6 md:py-3 rounded-lg transition duration-300 text-sm sm:text-base">Salvar</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Novo Modal de Confirmação -->
    <div id="confirmationModal" class="confirmation-modal">
        <div class="confirmation-modal-content">
            <p id="confirmationText"></p>
            <div class="flex justify-center space-x-4">
                <button id="confirmYesBtn" class="confirm-yes">Sim</button>
                <button id="confirmNoBtn" class="confirm-no">Não</button>
            </div>
        </div>
    </div>


    <!-- Seção do Rodapé -->
    <footer class="text-center p-5 mt-auto">
        <p class="text-xs sm:text-sm">&copy; 2025 Comanda Boulevard. Todos os direitos reservados.</p>
    </footer>

    <script>
        // Lógica JavaScript para o Comanda Boulevard
        document.addEventListener('DOMContentLoaded', () => {
            // --- Funções Auxiliares ---
            function showMessage(message) {
                const messageBox = document.getElementById('messageBox');
                const messageText = document.getElementById('messageText');
                messageText.textContent = message;
                messageBox.style.display = 'block';
            }

            // Função para exibir modal de confirmação
            let onConfirmCallback = null; // Callback para ser executado se o usuário confirmar

            function showConfirmationModal(message, callback) {
                const confirmationModal = document.getElementById('confirmationModal');
                const confirmationText = document.getElementById('confirmationText');
                confirmationText.textContent = message;
                onConfirmCallback = callback; // Armazena o callback
                confirmationModal.style.display = 'flex';
            }

            // Listeners para os botões do modal de confirmação
            document.getElementById('confirmYesBtn').addEventListener('click', () => {
                document.getElementById('confirmationModal').style.display = 'none';
                if (onConfirmCallback) {
                    onConfirmCallback(true); // Chama o callback com true para confirmar
                }
            });

            document.getElementById('confirmNoBtn').addEventListener('click', () => {
                document.getElementById('confirmationModal').style.display = 'none';
                if (onConfirmCallback) {
                    onConfirmCallback(false); // Chama o callback com false para cancelar
                }
            });


            // --- Lógica de Navegação por Abas ---
            const navLinks = document.querySelectorAll('.nav-link');
            const contentSections = document.querySelectorAll('.content-section');

            // --- Elementos de Gerenciamento de Produtos ---
            const productForm = document.getElementById('product-form');
            const productList = document.getElementById('product-list');
            const productSearchInput = document.getElementById('product-search');

            // Elementos do Modal de Edição de Produto
            const editProductModal = document.getElementById('editProductModal');
            const editProductForm = document.getElementById('edit-product-form');
            const editProductIdInput = document.getElementById('edit-product-id');
            const editProductNameInput = document.getElementById('edit-product-name');
            const editProductPriceInput = document.getElementById('edit-product-price');

            // --- Elementos de Gerenciamento de Mesas e Comandas ---
            const tablesContainer = document.querySelector('.tables-container');
            const currentTableNumberSpan = document.getElementById('current-table-number');
            const orderItemsList = document.getElementById('order-items');
            const orderTotalSpan = document.getElementById('order-total');
            const closeOrderButton = document.getElementById('close-order');
            const emptyOrderMessage = document.getElementById('empty-order-message');

            // Novos elementos para busca de produtos na seção de comanda
            const orderProductSearchInput = document.getElementById('order-product-search');
            const orderProductResultsList = document.getElementById('order-product-results');

            // Elementos do Modal de Edição de Nome da Mesa
            const editTableNameModal = document.getElementById('editTableNameModal');
            const editTableNameForm = document.getElementById('edit-table-name-form');
            const editTableIdInput = document.getElementById('edit-table-id');
            const newTableNameInput = document.getElementById('new-table-name');

            // Elementos para Importação de CSV
            const csvFileInput = document.getElementById('csv-file-input');
            const importCsvBtn = document.getElementById('import-csv-btn');

            // Botão para adicionar nova mesa
            const addNewTableBtn = document.getElementById('add-new-table-btn');

            let products = JSON.parse(localStorage.getItem('comandaProducts')) || [];
            let customTableNames = JSON.parse(localStorage.getItem('comandaCustomTableNames')) || {};
            let tableOrders = JSON.parse(localStorage.getItem('comandaTableOrders')) || {};
            let activeTableId = null; // ID da mesa atualmente selecionada

            const INITIAL_TABLES_COUNT = 5; // Número inicial de mesas

            // Lógica para inicializar ou carregar a contagem total de mesas
            // totalTablesCount agora representa o MAIOR ID de mesa já usado/existente
            let totalTablesCount = parseInt(localStorage.getItem('totalTablesCount')) || INITIAL_TABLES_COUNT;

            // Garante que as mesas iniciais estejam presentes e inicializadas
            function initializeTablesData() {
                let changed = false;
                // Certifica-se de que customTableNames e tableOrders tenham entradas para as mesas existentes
                for (let i = 1; i <= totalTablesCount; i++) {
                    const tableId = `table-${i}`;
                    // Só adiciona se não existir, para não sobrescrever nomes personalizados ou estados de comanda
                    if (!customTableNames[tableId]) {
                        customTableNames[tableId] = `Mesa ${i}`;
                        changed = true;
                    }
                    if (!tableOrders[tableId]) {
                        tableOrders[tableId] = { items: [], occupied: false };
                        changed = true;
                    }
                }
                // Remove quaisquer mesas que possam ter IDs maiores do que totalTablesCount, se o usuário diminuiu
                // Isso é para o caso de um usuário manualmente diminuir totalTablesCount no localStorage
                // ou se quisermos garantir que não haja "mesas fantasmas" após uma redução
                // Nota: Essa parte é mais para robustez contra manipulação manual do localStorage.
                // Na operação normal, totalTablesCount só aumenta.
                for (const tableId in customTableNames) {
                    const num = parseInt(tableId.replace('table-', ''));
                    if (num > totalTablesCount) {
                        delete customTableNames[tableId];
                        delete tableOrders[tableId]; // Remove também os pedidos associados
                        changed = true;
                    }
                }

                if (changed) {
                    localStorage.setItem('comandaCustomTableNames', JSON.stringify(customTableNames));
                    localStorage.setItem('comandaTableOrders', JSON.stringify(tableOrders));
                    localStorage.setItem('totalTablesCount', totalTablesCount.toString());
                }
            }


            function showSection(sectionId) {
                // Esconde todas as seções
                contentSections.forEach(section => {
                    section.classList.add('hidden');
                });
                // Mostra a seção alvo
                document.getElementById(sectionId).classList.remove('hidden');

                // Atualiza o estilo da aba ativa
                navLinks.forEach(link => {
                    link.classList.remove('active-tab');
                });
                document.querySelector(`nav a[href="#${sectionId}"]`).classList.add('active-tab');

                 // Re-renderiza dados relevantes ao trocar de aba
                if (sectionId === 'cadastro') {
                    renderProducts();
                    productSearchInput.value = ''; // Limpa a busca ao navegar para a aba de produtos
                } else if (sectionId === 'relatorio') {
                    renderSalesReport();
                } else if (sectionId === 'comanda') {
                    renderTables(); // Garante que as mesas sejam renderizadas/re-renderizadas
                    orderProductSearchInput.value = ''; // Limpa a busca de produtos da comanda
                    orderProductResultsList.classList.add('hidden'); // Esconde os resultados da busca
                }
            }

            // Adiciona listeners de clique aos links de navegação
            navLinks.forEach(link => {
                link.addEventListener('click', (e) => {
                    e.preventDefault(); // Previne o comportamento padrão do link de âncora
                    const sectionId = e.target.getAttribute('href').substring(1); // Obtém o ID sem '#'
                    showSection(sectionId);
                });
            });

            // Mostra a seção 'Comanda' por padrão ao carregar a página
            initializeTablesData(); // Garante que os dados das mesas estão prontos antes de renderizar
            showSection('comanda');


            // Renderiza produtos na lista e dropdown de seleção
            // Recebe um array opcional 'displayProducts' para filtrar o que é mostrado na lista
            function renderProducts(displayProducts = products) {
                productList.innerHTML = '';

                if (displayProducts.length === 0 && productSearchInput.value === '') {
                    productList.innerHTML = '<p class="text-gray-500 italic">Nenhum produto cadastrado.</p>';
                } else if (displayProducts.length === 0 && productSearchInput.value !== '') {
                     productList.innerHTML = '<p class="text-gray-500 italic">Nenhum produto encontrado com este termo.</p>';
                }

                displayProducts.forEach((product) => { // Renderiza produtos filtrados na lista
                    const li = document.createElement('li');
                    li.className = 'product-item p-3 mb-2 sm:p-4 sm:mb-3 text-sm sm:text-base';
                    li.innerHTML = `
                            <span class="text-lg font-medium">${product.name}</span>
                            <span class="text-lg font-semibold text-gray-700">R$ ${product.price.toFixed(2)}</span>
                            <div class="flex flex-col sm:flex-row space-y-2 sm:space-y-0 sm:space-x-2 mt-2 sm:mt-0">
                                <button data-id="${product.id}" class="edit-product-btn bg-blue-500 hover:bg-blue-700 px-3 py-1.5 sm:px-4 sm:py-2">Editar</button>
                                <button data-id="${product.id}" class="remove-product-btn bg-red-500 hover:bg-red-700 px-3 py-1.5 sm:px-4 sm:py-2">Remover</button>
                            </div>
                        `;
                    productList.appendChild(li);
                });

                // Adiciona listeners de evento para botões de edição e remoção
                document.querySelectorAll('.edit-product-btn').forEach(button => {
                    button.addEventListener('click', (e) => {
                        const productId = e.target.dataset.id;
                        editProduct(productId);
                    });
                });

                document.querySelectorAll('.remove-product-btn').forEach(button => {
                    button.addEventListener('click', (e) => {
                        const productId = e.target.dataset.id;
                        removeProduct(productId);
                    });
                });
            }

            // Função para lidar com a remoção de produtos
            function removeProduct(productId) {
                const indexToRemove = products.findIndex(p => p.id === productId);
                if (indexToRemove !== -1) {
                    products.splice(indexToRemove, 1);
                    localStorage.setItem('comandaProducts', JSON.stringify(products));
                    renderProducts(); // Re-renderiza todos os produtos após a remoção
                    productSearchInput.value = ''; // Limpa a busca
                    showMessage('Produto removido!');
                }
            }


            // Função para preencher o modal de edição e mostrá-lo
            function editProduct(productId) {
                const productToEdit = products.find(p => p.id === productId);
                if (productToEdit) {
                    editProductIdInput.value = productToEdit.id;
                    editProductNameInput.value = productToEdit.name;
                    editProductPriceInput.value = productToEdit.price;
                    editProductModal.style.display = 'flex'; // Usa flex para centralizar o modal
                }
            }

            // Lida com o envio do formulário de produto (para adicionar novo produto)
            productForm.addEventListener('submit', (e) => {
                e.preventDefault();
                const productName = document.getElementById('product-name').value.trim();
                const productPrice = parseFloat(document.getElementById('product-price').value);

                if (productName && !isNaN(productPrice) && productPrice > 0) {
                    const newProduct = {
                        id: Date.now().toString(), // ID único para o produto
                        name: productName,
                        price: productPrice
                    };
                    products.push(newProduct);
                    localStorage.setItem('comandaProducts', JSON.stringify(products));
                    renderProducts();
                    productForm.reset();
                    productSearchInput.value = ''; // Limpa a busca
                    showMessage('Produto cadastrado com sucesso!');
                } else {
                    showMessage('Por favor, preencha o nome do produto e um preço válido (maior que zero).');
                }
            });

            // Lida com o envio do formulário de edição de produto
            editProductForm.addEventListener('submit', (e) => {
                e.preventDefault();
                const productId = editProductIdInput.value;
                const newName = editProductNameInput.value.trim();
                const newPrice = parseFloat(editProductPriceInput.value);

                if (newName && !isNaN(newPrice) && newPrice > 0) {
                    const productIndex = products.findIndex(p => p.id === productId);
                    if (productIndex !== -1) {
                        products[productIndex].name = newName;
                        products[productIndex].price = newPrice;
                        localStorage.setItem('comandaProducts', JSON.stringify(products));
                        renderProducts(); // Re-renderiza todos os produtos
                        editProductModal.style.display = 'none'; // Esconde o modal
                        showMessage('Produto atualizado com sucesso!');
                    }
                } else {
                    showMessage('Por favor, preencha o nome do produto e um preço válido (maior que zero) para a edição.');
                }
            });

            // Listener de evento para o input de busca de produtos
            productSearchInput.addEventListener('input', (e) => {
                const searchTerm = e.target.value.toLowerCase();
                const filteredProducts = products.filter(product =>
                    product.name.toLowerCase().includes(searchTerm)
                );
                renderProducts(filteredProducts); // Renderiza apenas produtos filtrados
            });

            // --- Gerenciamento de Mesas e Comandas ---
            // Renderiza elementos da mesa e define o estado inicial
            function renderTables() {
                tablesContainer.innerHTML = ''; // Limpa as mesas existentes
                // Itera até o maior ID de mesa registrado
                for (let i = 1; i <= totalTablesCount; i++) {
                    const tableId = `table-${i}`;
                    // Renderiza a mesa apenas se ela existir nos dados (não foi removida)
                    if (customTableNames[tableId]) {
                        const tableName = customTableNames[tableId];
                        const tableDiv = document.createElement('div');
                        tableDiv.id = tableId;
                        tableDiv.className = `table cursor-pointer p-3 sm:p-4 md:p-5 rounded-lg shadow-md hover:scale-105 transition-transform duration-200 text-base sm:text-lg ${tableOrders[tableId] && tableOrders[tableId].occupied ? 'occupied' : ''}`;
                        tableDiv.innerHTML = `
                            <span>${tableName}</span>
                            <button class="edit-table-btn" data-table-id="${tableId}" title="Editar Nome da Mesa">
                                ✎
                            </button>
                            <button class="remove-table-btn" data-table-id="${tableId}" title="Remover Mesa">
                                X
                            </button>
                        `;
                        tableDiv.dataset.tableNumber = i; // Armazena o número da mesa

                        // Adiciona o listener de dblclick a cada mesa (para selecionar)
                        tableDiv.addEventListener('dblclick', (e) => {
                            // Garante que o dblclick nos botões não ative a seleção da mesa
                            if (!e.target.classList.contains('edit-table-btn') && !e.target.classList.contains('remove-table-btn')) {
                                selectNewTable(tableId);
                            }
                        });

                        // Adiciona o listener de click para o botão de edição
                        const editButton = tableDiv.querySelector('.edit-table-btn');
                        if (editButton) {
                            editButton.addEventListener('click', (e) => {
                                e.stopPropagation();
                                const tableToEditId = e.target.dataset.tableId;
                                openEditTableNameModal(tableToEditId);
                            });
                        }

                        // Adiciona o listener de click para o botão de remoção
                        const removeButton = tableDiv.querySelector('.remove-table-btn');
                        if (removeButton) {
                            removeButton.addEventListener('click', (e) => {
                                e.stopPropagation();
                                const tableToRemoveId = e.target.dataset.tableId;
                                showConfirmationModal(`Tem certeza que deseja remover a ${customTableNames[tableToRemoveId]}? Todos os dados da comanda serão perdidos.`, (confirmed) => {
                                    if (confirmed) {
                                        removeTable(tableToRemoveId);
                                    }
                                });
                            });
                        }

                        tablesContainer.appendChild(tableDiv);
                    }
                }
                // Salva o estado atual das mesas após a renderização para garantir consistência
                localStorage.setItem('comandaCustomTableNames', JSON.stringify(customTableNames));
                localStorage.setItem('comandaTableOrders', JSON.stringify(tableOrders));
                localStorage.setItem('totalTablesCount', totalTablesCount.toString());
            }

            // Função para remover uma mesa
            function removeTable(tableId) {
                // Remove a mesa dos dados
                delete customTableNames[tableId];
                delete tableOrders[tableId];

                // Se a mesa removida for a mesa ativa, desativa-a
                if (activeTableId === tableId) {
                    activeTableId = null;
                    currentTableNumberSpan.textContent = 'Nenhuma';
                    renderCurrentOrder(); // Limpa a exibição da comanda
                }

                // Salva as alterações no localStorage
                localStorage.setItem('comandaCustomTableNames', JSON.stringify(customTableNames));
                localStorage.setItem('comandaTableOrders', JSON.stringify(tableOrders));
                // totalTablesCount não é decrementado, pois representa o maior ID já usado.
                // Isso evita reindexação complexa e mantém IDs únicos.

                renderTables(); // Re-renderiza as mesas para refletir a remoção
                showMessage(`Mesa ${tableId.replace('table-', '')} removida com sucesso!`);
            }


            // Seleciona uma nova mesa, atualiza a UI e carrega/cria a comanda
            function selectNewTable(tableId) {
                // Desseleciona a mesa anterior, se houver
                if (activeTableId) {
                    const prevTableElement = document.getElementById(activeTableId);
                    if (prevTableElement) {
                        prevTableElement.classList.remove('active');
                    }
                }

                // Define a nova mesa ativa
                activeTableId = tableId;
                const currentTableElement = document.getElementById(activeTableId);
                if (currentTableElement) {
                    currentTableElement.classList.add('active');
                }

                currentTableNumberSpan.textContent = customTableNames[activeTableId] || (currentTableElement ? currentTableElement.querySelector('span').textContent : 'Nenhuma');

                // Inicializa a comanda para a mesa se ela não existir
                if (!tableOrders[activeTableId]) {
                    tableOrders[activeTableId] = { items: [], occupied: false };
                }

                // Marca como ocupada se ainda não estiver, e atualiza o armazenamento
                if (!tableOrders[activeTableId].occupied) {
                    tableOrders[activeTableId].occupied = true;
                    // Adiciona a classe 'occupied' ao elemento da mesa
                    if (currentTableElement) {
                        currentTableElement.classList.add('occupied');
                    }
                    localStorage.setItem('comandaTableOrders', JSON.stringify(tableOrders));
                }

                renderCurrentOrder();
                // Limpa e esconde os resultados da busca de produtos ao selecionar uma nova mesa
                orderProductSearchInput.value = '';
                orderProductResultsList.classList.add('hidden');
            }

            // Função para abrir o modal de edição de nome da mesa
            function openEditTableNameModal(tableId) {
                editTableIdInput.value = tableId;
                newTableNameInput.value = customTableNames[tableId] || document.getElementById(tableId).querySelector('span').textContent;
                editTableNameModal.style.display = 'flex';
            }

            // Lida com o envio do formulário de edição de nome da mesa
            editTableNameForm.addEventListener('submit', (e) => {
                e.preventDefault();
                const tableId = editTableIdInput.value;
                const newName = newTableNameInput.value.trim();

                if (newName) {
                    customTableNames[tableId] = newName;
                    localStorage.setItem('comandaCustomTableNames', JSON.stringify(customTableNames));
                    renderTables(); // Re-renderiza todas as mesas para refletir o novo nome
                    // Se o nome da mesa atualmente ativa foi alterado, atualiza sua exibição
                    if (activeTableId === tableId) {
                        currentTableNumberSpan.textContent = newName;
                    }
                    editTableNameModal.style.display = 'none';
                    showMessage(`Nome da ${newName} atualizado!`);
                } else {
                    showMessage('Por favor, digite um novo nome para a mesa.');
                }
            });

            // Event listener para o botão "Adicionar Mesa"
            addNewTableBtn.addEventListener('click', () => {
                totalTablesCount++; // Incrementa a contagem total de mesas
                const newTableId = `table-${totalTablesCount}`;

                // Inicializa os dados para a nova mesa
                customTableNames[newTableId] = `Mesa ${totalTablesCount}`;
                tableOrders[newTableId] = { items: [], occupied: false };

                // Salva a nova contagem e os novos dados no localStorage
                localStorage.setItem('totalTablesCount', totalTablesCount.toString());
                localStorage.setItem('comandaCustomTableNames', JSON.stringify(customTableNames));
                localStorage.setItem('comandaTableOrders', JSON.stringify(tableOrders));

                renderTables(); // Re-renderiza todas as mesas para incluir a nova
                showMessage(`Mesa ${totalTablesCount} adicionada!`);
            });


            // Renderiza os itens e o total da comanda da mesa atualmente ativa
            function renderCurrentOrder() {
                orderItemsList.innerHTML = ''; // Limpa os itens anteriores
                let total = 0;

                if (activeTableId && tableOrders[activeTableId] && tableOrders[activeTableId].items.length > 0) {
                    emptyOrderMessage.style.display = 'none'; // Esconde a mensagem de vazio
                    tableOrders[activeTableId].items.forEach((item, index) => {
                        const li = document.createElement('li');
                        li.className = 'order-item p-3 mb-2 sm:p-4 sm:mb-3 text-sm sm:text-base';
                        li.innerHTML = `
                            <span class="font-medium">${item.name} (x${item.quantity})</span>
                            <span class="font-bold text-gray-800">R$ ${(item.price * item.quantity).toFixed(2)}</span>
                            <div class="flex space-x-2">
                                <button data-index="${index}" class="increment-item-btn bg-blue-500 hover:bg-blue-700 px-3 py-1.5 sm:px-4 sm:py-2">+</button>
                                <button data-index="${index}" class="decrement-item-btn bg-yellow-500 hover:bg-yellow-700 px-3 py-1.5 sm:px-4 sm:py-2">-</button>
                                <button data-index="${index}" class="remove-item-btn bg-red-500 hover:bg-red-700 px-3 py-1.5 sm:px-4 sm:py-2">Remover</button>
                            </div>
                        `;
                        orderItemsList.appendChild(li);
                        total += item.price * item.quantity;
                    });
                } else {
                    emptyOrderMessage.style.display = 'block'; // Mostra a mensagem de vazio
                }

                orderTotalSpan.textContent = total.toFixed(2);

                // Adiciona listeners de evento para os botões de item da comanda
                document.querySelectorAll('.increment-item-btn').forEach(button => {
                    button.addEventListener('click', (e) => updateOrderItemQuantity(e.target.dataset.index, 1));
                });
                document.querySelectorAll('.decrement-item-btn').forEach(button => {
                    button.addEventListener('click', (e) => updateOrderItemQuantity(e.target.dataset.index, -1));
                });
                document.querySelectorAll('.remove-item-btn').forEach(button => {
                    button.addEventListener('click', (e) => removeOrderItem(e.target.dataset.index));
                });
            }

            // Função para adicionar um produto à comanda atual diretamente de um objeto de produto
            function addProductToCurrentOrder(product) {
                if (!activeTableId) {
                    showMessage('Por favor, selecione uma mesa primeiro.');
                    return;
                }
                const order = tableOrders[activeTableId];
                const existingItem = order.items.find(item => item.id === product.id);

                if (existingItem) {
                    existingItem.quantity++;
                } else {
                    order.items.push({ ...product, quantity: 1 });
                }
                localStorage.setItem('comandaTableOrders', JSON.stringify(tableOrders));
                renderCurrentOrder();
                showMessage(`${product.name} adicionado à comanda.`);

                orderProductSearchInput.value = ''; // Limpa o input de busca após adicionar
                orderProductResultsList.classList.add('hidden'); // Esconde a lista de resultados
            }

            // Atualiza a quantidade de um item na comanda atual
            function updateOrderItemQuantity(index, change) {
                const order = tableOrders[activeTableId];
                if (order && order.items[index]) {
                    order.items[index].quantity += change;
                    if (order.items[index].quantity <= 0) {
                        order.items.splice(index, 1); // Remove se a quantidade for zero ou menos
                    }
                    localStorage.setItem('comandaTableOrders', JSON.stringify(tableOrders));
                    renderCurrentOrder();
                }
            }

            // Remove um item da comanda atual
            function removeOrderItem(index) {
                const order = tableOrders[activeTableId];
                if (order && order.items[index]) {
                    const removedProductName = order.items[index].name;
                    order.items.splice(index, 1);
                    localStorage.setItem('comandaTableOrders', JSON.stringify(tableOrders));
                    renderCurrentOrder();
                    showMessage(`${removedProductName} removido da comanda.`);
                }
            }

            // Fecha a comanda atual e adiciona ao relatório de vendas
            closeOrderButton.addEventListener('click', () => {
                if (!activeTableId) {
                    showMessage('Nenhuma mesa selecionada para fechar a comanda.');
                    return;
                }

                const order = tableOrders[activeTableId];
                // Permitir fechar mesa vazia
                if (order && order.items.length > 0) {
                    let salesReport = JSON.parse(localStorage.getItem('comandaSalesReport')) || [];
                    salesReport.push({
                        id: Date.now().toString(),
                        tableId: activeTableId,
                        items: order.items,
                        total: parseFloat(orderTotalSpan.textContent),
                        date: new Date().toLocaleString()
                    });
                    localStorage.setItem('comandaSalesReport', JSON.stringify(salesReport));
                    showMessage('Comanda fechada e venda registrada com sucesso!');
                } else {
                    showMessage('Mesa vazia liberada.');
                }

                // Limpa a comanda da mesa e marca como livre
                delete tableOrders[activeTableId];
                localStorage.setItem('comandaTableOrders', JSON.stringify(tableOrders));

                const tableElement = document.getElementById(activeTableId);
                if (tableElement) {
                    tableElement.classList.remove('occupied');
                    tableElement.classList.remove('active'); // Remove também o estado ativo
                }

                activeTableId = null; // Desseleciona a mesa
                currentTableNumberSpan.textContent = 'Nenhuma';
                renderCurrentOrder(); // Limpa a exibição da comanda

                renderSalesReport(); // Atualiza a exibição do relatório de vendas
                renderTables(); // Re-renderiza as mesas para garantir a atualização visual
            });

            // --- Nova Lógica de Busca de Produtos para Comanda ---
            orderProductSearchInput.addEventListener('focus', () => {
                // Ao focar, se o input estiver vazio, mostra todos os produtos
                if (products.length > 0 && orderProductSearchInput.value.trim() === '') {
                    displayOrderProducts(products);
                }
            });

            orderProductSearchInput.addEventListener('input', () => {
                const searchTerm = orderProductSearchInput.value.toLowerCase().trim();
                orderProductResultsList.innerHTML = ''; // Limpa os resultados anteriores

                if (searchTerm.length > 0) {
                    const filteredProducts = products.filter(product =>
                        product.name.toLowerCase().startsWith(searchTerm)
                    );
                    displayOrderProducts(filteredProducts);
                } else {
                    // Se o campo de busca estiver vazio, exibe todos os produtos novamente
                    displayOrderProducts(products);
                }
            });

            function displayOrderProducts(productsToDisplay) {
                orderProductResultsList.innerHTML = '';
                if (productsToDisplay.length > 0) {
                    productsToDisplay.forEach(product => {
                        const li = document.createElement('li');
                        li.className = 'order-product-result-item text-sm sm:text-base';
                        li.innerHTML = `
                            <span>${product.name}</span>
                            <span class="font-bold text-gray-700 mr-2">R$ ${product.price.toFixed(2)}</span>
                            <button class="add-product-list-btn" data-product-id="${product.id}">Adicionar</button>
                        `;
                        orderProductResultsList.appendChild(li);
                    });
                    orderProductResultsList.classList.remove('hidden'); // Mostra os resultados

                    // Adiciona listeners de evento para os novos botões "Adicionar"
                    document.querySelectorAll('.add-product-list-btn').forEach(button => {
                        button.addEventListener('click', (e) => {
                            e.stopPropagation(); // Previne problemas se o item em si fosse clicável
                            const productId = e.target.dataset.productId;
                            const productToAdd = products.find(p => p.id === productId);
                            if (productToAdd) {
                                addProductToCurrentOrder(productToAdd);
                            }
                        });
                    });

                } else {
                    orderProductResultsList.classList.add('hidden'); // Esconde se não houver resultados
                }
            }


            // Esconde os resultados ao clicar fora da área de busca
            document.addEventListener('click', (event) => {
                if (!orderProductSearchInput.contains(event.target) && !orderProductResultsList.contains(event.target)) {
                    orderProductResultsList.classList.add('hidden');
                }
            });

            // --- Lógica de Importação de CSV ---
            importCsvBtn.addEventListener('click', () => {
                const file = csvFileInput.files[0];
                if (!file) {
                    showMessage('Por favor, selecione um arquivo CSV para importar.');
                    return;
                }

                const reader = new FileReader();
                reader.onload = (e) => {
                    const csvText = e.target.result;
                    const lines = csvText.split('\n').filter(line => line.trim() !== ''); // Filtra linhas vazias
                    let importedCount = 0;

                    lines.forEach(line => {
                        const parts = line.split(',');
                        if (parts.length === 2) {
                            const name = parts[0].trim();
                            const price = parseFloat(parts[1].trim());

                            if (name && !isNaN(price) && price > 0) {
                                // Verifica se o produto já existe pelo nome para evitar duplicações visuais
                                // Nota: Ainda criamos um novo ID único, então eles são distintos nos dados.
                                const existingProduct = products.find(p => p.name.toLowerCase() === name.toLowerCase());
                                if (!existingProduct) {
                                    const newProduct = {
                                        id: Date.now().toString() + importedCount, // ID único
                                        name: name,
                                        price: price
                                    };
                                    products.push(newProduct);
                                    importedCount++;
                                } else {
                                    console.warn(`Produto "${name}" já existe e será ignorado na importação.`);
                                }
                            }
                        }
                    });

                    localStorage.setItem('comandaProducts', JSON.stringify(products));
                    renderProducts(); // Re-renderiza a lista de produtos
                    csvFileInput.value = ''; // Limpa o input do arquivo
                    if (importedCount > 0) {
                        showMessage(`${importedCount} produtos importados com sucesso do CSV!`);
                    } else {
                        showMessage('Nenhum novo produto válido foi encontrado para importar do CSV.');
                    }
                };

                reader.onerror = () => {
                    showMessage('Erro ao ler o arquivo CSV.');
                };

                reader.readAsText(file);
            });


            // --- Relatório de Vendas ---
            const salesReportContent = document.getElementById('sales-report-content');

            // Renderiza o relatório de vendas
            function renderSalesReport() {
                let salesReport = JSON.parse(localStorage.getItem('comandaSalesReport')) || [];
                salesReportContent.innerHTML = ''; // Limpa o conteúdo anterior

                if (salesReport.length === 0) {
                    salesReportContent.innerHTML = '<p class="text-gray-500 italic">Nenhuma venda registrada ainda.</p>';
                    return;
                }

                let grandTotal = 0;
                let reportHtml = '<h3 class="text-xl sm:text-2xl font-semibold mb-4">Histórico de Vendas:</h3>';

                salesReport.forEach(sale => {
                    reportHtml += `
                        <div class="sale-entry mb-4 p-3 sm:p-4 border rounded-lg shadow-sm bg-gray-50">
                            <h4 class="text-lg sm:text-xl font-bold text-gray-800 mb-2">Venda na ${customTableNames[sale.tableId] || sale.tableId.replace('table-', 'Mesa ')} <span class="text-sm sm:text-base text-gray-600 font-normal">(${sale.date})</span></h4>
                            <ul class="list-disc pl-5 mb-2 text-gray-700 text-sm sm:text-base">
                    `;
                    sale.items.forEach(item => {
                        reportHtml += `<li>${item.name} (x${item.quantity}) - R$ ${(item.price * item.quantity).toFixed(2)}</li>`;
                    });
                    reportHtml += `
                            </ul>
                            <p class="text-base sm:text-lg font-bold text-right text-green-700">Total da Venda: R$ ${sale.total.toFixed(2)}</p>
                        </div>
                    `;
                    grandTotal += sale.total;
                });

                reportHtml += `<h3 class="text-xl sm:text-2xl font-bold mt-6 text-right text-blue-800">Total Geral de Vendas: R$ ${grandTotal.toFixed(2)}</h3>`;
                salesReportContent.innerHTML = reportHtml;
            }
        });
    </script>
</body>
</html>
