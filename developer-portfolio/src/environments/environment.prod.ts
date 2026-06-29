export const environment = {
  production: true,
  siteUrl: 'https://www.your-domain.com',
  emailjs: {
    serviceId: '',
    templateId: '',
    publicKey: ''
  },
  api: {
    idaBaseUrl: '/api/ida',
    fcubsUrl: '/api/fcubs',
    contactUrl: '/api/contact'
  },
  bankDefaults: {
    branchCode: '109',
    branchLocation: 'AA',
    nationality: 'ETH',
    country: 'ETH',
    accountClass: 'SPIA',
    accountType: 'S',
    media: 'MAIL',
    customerCategory: 'IND',
    source: 'PAP',
    userId: 'PAPERLESS',
    ubsComp: 'FCUBS',
    service: 'FCUBSCustomerService',
    operation: 'CreateCustomer'
  }
};
