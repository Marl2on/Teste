public with sharing class Cal_Servico_Repo_AggregateProduct {
    /// Busca produto pelo ID
    public Product2 GetProductById(string Id)
    {
        List<Product2> retorno =  [
            SELECT 
            id,
            TW1_Unidade__c,
            TW1_Conta__c,
            TW1_Codigo_Personalizacao_UAU__c, 
            TW1_Data_Habite_se__c, 
            TW1_Data_Averbacao_Habite_se__c, 
            TW1_Bloco__c, 
            TW1_Numero_Venda__c,
            TW1_Empresa__c,
            TW1_Empreendimento__c,
            TW1_Codigo_Empresa_UAU__c,		
            TW1_Codigo_Empreendimento_UAU__c,
            TW1_Codigo_Bloco_UAU__c,                   
            TW1_Data_da_Venda__c,
            TW1_Saldo_Devedor_UAU__c,
            TW1_Valor_da_Venda_UAU__c,
            TW1_Valor_de_Venda_Atualizado_UAU__c,
            TW1_Valor_Total_Pago_UAU__c,
            TW1_Codigo_Conta_UAU__c,
            TW1_Bloco__r.TW1_Responsavel_Manutencao_Vistoria__c
            FROM Product2 
            WHERE 
            Id = :Id];
        
        if(retorno.Size() == 0)
            return null;
        else
            return retorno[0];
    }
    
    /// Busca lista de unidades vendidas, essas estão com o contrato ativo e fluxo de pagamento em aberto
    public Map<Id, Product2> GetListaUnidadesContratosAtivos()
    {
        Map<Id, Product2> mapper = new Map<Id, Product2>([SELECT 
                                                          id, 
                                                          TW1_Codigo_Bloco_UAU__c,
                                                          TW1_Unidade__c,
                                                          TW1_Codigo_Empreendimento_UAU__c,
                                                          TW1_Codigo_Empresa_UAU__c,
                                                          TW1_Codigo_Personalizacao_UAU__c,
                                                          TW1_Numero_Venda__c,
                                                          TW1_Data_da_Venda__c,
                                                          TW1_Saldo_Devedor_UAU__c,
                                                          TW1_Valor_da_Venda_UAU__c,
                                                          TW1_Valor_de_Venda_Atualizado_UAU__c,
                                                          TW1_Valor_Total_Pago_UAU__c
                                                          FROM Product2
                                                          WHERE Tw1_Status__c = 'Vendida' AND TW1_Numero_Venda__c != null]);
        return mapper;
    }
    
    /// Busca lista de unidades onde o Id é o nome da unidade
    public Map<string, Product2> GelListaUnidadesPorBloco(Id idBloco)
    {
        /// Monta mapper com o nome da unidade como chave
        Map<string, Product2> mapper = new Map<string, Product2>();
        
        /// Busca todas as unidades de um determinado bloco.
        for(Product2 produto : [SELECT id, Name FROM Product2 WHERE TW1_Bloco__c = :idBloco])
            mapper.put(produto.Name, produto);
        
        return mapper;
    }
    
    public void Atualizar(Product2 unidade)
    {
        update unidade;
    }
    
    public void Incluir(Product2 unidade)
    {
        insert unidade;
    }
    
    public void AtualizarRange(List<Product2> unidades)
    {
        update unidades;
    }
    
    public void IncluirRange(List<Product2> unidades)
    {
        insert unidades;
    }
    /// Inserir ou atualizar empresa
    public void InserirAtualizarEmpresa(TW1_Empresa__c empresa)
    {
        List<TW1_Empresa__c> empresas = [select id FROM  TW1_Empresa__c where TW1_cod_empresa_UAU__c = :empresa.TW1_cod_empresa_UAU__c]; 
        
        if(empresas.Size() == 0)
            insert empresa;
        else
        {
            empresa.Id = empresas[0].Id;
            update empresa;
        }        
    }
    
    public void InserirAtualizarEmpreendimento(TW1_Empreendimento__c empreendimento)
    {
        List<TW1_Empreendimento__c> empreendimentos = [select id FROM  TW1_Empreendimento__c where TW1_Codigo_Obra_UAU__c = :empreendimento.TW1_Codigo_Obra_UAU__c]; 
        
        if(empreendimentos.Size() == 0)
            insert empreendimento;
        else
        {
            empreendimento.Id = empreendimentos[0].Id;
            update empreendimento;
        }    
    }
    
    public void InserirAtualizarBloco(TW1_Bloco__c bloco)
    {
        List<TW1_Bloco__c> blocos = [select id FROM  TW1_Bloco__c where TW1_Codigo_Produto_UAU__c = :bloco.TW1_Codigo_Produto_UAU__c]; 
        
        if(blocos.Size() == 0)
            insert bloco;
        else
        {
            bloco.Id = blocos[0].Id;
            update bloco;
        }    
    }   
    
    public Product2 GetUnidadePorEmpresaObraVenda(string codigoEmpresa, string codigoObra, string numeroVenda)
    {
        List<Product2> listaUnidades = [SELECT 
                                        id,
                                        name,
                                        TW1_Conta__c,
                                        TW1_Unidade__c,
                                        TW1_Codigo_Personalizacao_UAU__c, 
                                        TW1_Data_Habite_se__c, 
                                        TW1_Data_Averbacao_Habite_se__c, 
                                        TW1_Bloco__c, 
                                        TW1_Numero_Venda__c,
                                        TW1_Empresa__c,
                                        TW1_Empreendimento__c,                                        
                                        TW1_Codigo_Empresa_UAU__c,		
                                        TW1_Codigo_Empreendimento_UAU__c,
                                        TW1_Codigo_Bloco_UAU__c,
                                        TW1_Nome_Bloco__c,
                                        TW1_Data_da_Venda__c,
                                        TW1_Saldo_Devedor_UAU__c,
                                        TW1_Valor_da_Venda_UAU__c,
                                        TW1_Valor_de_Venda_Atualizado_UAU__c,
                                        TW1_Valor_Total_Pago_UAU__c,
                                        TW1_Codigo_Conta_UAU__c,
                                        TW1_Bloco__r.TW1_Responsavel_Manutencao_Vistoria__c
                                        FROM Product2  
                                        WHERE TW1_Codigo_Empresa_UAU__c =:codigoEmpresa 
                                        AND TW1_Codigo_Empreendimento_UAU__c =: codigoObra 
                                        AND TW1_Numero_Venda__c =:numeroVenda];
        
        if(listaUnidades.size() <1)
            return null;
        else
            return listaUnidades[0];
    }
    
    public Product2 GetUnidadePorEmpresaObraPersonalisacao(string codigoEmpresa, string codigoObra, string codigoPersonalisacao)
    {
        List<Product2> listaUnidades = [SELECT 
                                        id,
                                        name,
                                        TW1_Conta__c,
                                        TW1_Unidade__c,
                                        TW1_Codigo_Personalizacao_UAU__c, 
                                        TW1_Data_Habite_se__c, 
                                        TW1_Data_Averbacao_Habite_se__c, 
                                        TW1_Bloco__c, 
                                        TW1_Numero_Venda__c,
                                        TW1_Empresa__c,
                                        TW1_Empreendimento__c,                                        
                                        TW1_Codigo_Empresa_UAU__c,		
                                        TW1_Codigo_Empreendimento_UAU__c,
                                        TW1_Codigo_Produto_UAU__c,
                                        TW1_Codigo_Bloco_UAU__c,
                                        TW1_Nome_Bloco__c,
                                        TW1_Data_da_Venda__c,
                                        TW1_Saldo_Devedor_UAU__c,
                                        TW1_Valor_da_Venda_UAU__c,
                                        TW1_Valor_de_Venda_Atualizado_UAU__c,
                                        TW1_Valor_Total_Pago_UAU__c,
                                        TW1_Codigo_Conta_UAU__c,
                                        TW1_Bloco__r.TW1_Responsavel_Manutencao_Vistoria__c
                                        FROM Product2  
                                        WHERE TW1_Codigo_Empresa_UAU__c =:codigoEmpresa 
                                        AND TW1_Codigo_Produto_UAU__c =: codigoObra 
                                        AND TW1_Codigo_Personalizacao_UAU__c =:codigoPersonalisacao];
        
        if(listaUnidades.size() <1)
            return null;
        else
            return listaUnidades[0];
    }
    
    
    public List<Product2> GetTodasPropriedadesDeUmCLiente(string accountId)
    {
        return [SELECT 
                id,
                name,
                TW1_Unidade__c,
                TW1_Conta__c,
                TW1_Codigo_Personalizacao_UAU__c, 
                TW1_Data_Habite_se__c, 
                TW1_Data_Averbacao_Habite_se__c, 
                TW1_Bloco__c, 
                TW1_Numero_Venda__c,
                TW1_Empresa__c,
                TW1_Empreendimento__c,
                TW1_Codigo_Empresa_UAU__c,		
                TW1_Codigo_Empreendimento_UAU__c,
                TW1_Codigo_Bloco_UAU__c,
                TW1_Nome_Bloco__c,
                TW1_Data_da_Venda__c,
                TW1_Saldo_Devedor_UAU__c,
                TW1_Valor_da_Venda_UAU__c,
                TW1_Valor_de_Venda_Atualizado_UAU__c,
                TW1_Valor_Total_Pago_UAU__c,
                TW1_Codigo_Conta_UAU__c,
                TW1_Bloco__r.TW1_Responsavel_Manutencao_Vistoria__c
                FROM Product2  
                WHERE TW1_Conta__c = :accountId];
    }
}