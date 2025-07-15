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
