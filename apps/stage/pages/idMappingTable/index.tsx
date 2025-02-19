import IdMappingTable from '@/components/pages/explorationTables/idMappingTable';
import { createPage } from '@/global/utils/pages';

const IdMappingPage = createPage({
	getInitialProps: async ({ query, egoJwt }) => {
		return { query, egoJwt };
	},
	isPublic: true,
})(() => {
	return <IdMappingTable />;
});

export default IdMappingPage;
